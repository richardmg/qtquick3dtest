#include "mousearea3d.h"

#include <QtQml>
#include <QGuiApplication>

QT_BEGIN_NAMESPACE

MouseArea3D *MouseArea3D::s_mouseGrab = nullptr;

MouseArea3D::MouseArea3D(QQuick3DNode *parent)
    : QObject(parent)
{
}

QQuick3DViewport *MouseArea3D::view3D() const
{
    return m_view3D;
}

bool MouseArea3D::hovering() const
{
    return m_hovering;
}

bool MouseArea3D::dragging() const
{
    return m_dragging;
}

qreal MouseArea3D::x() const
{
    return m_x;
}

qreal MouseArea3D::y() const
{
    return m_y;
}

qreal MouseArea3D::width() const
{
    return m_width;
}

qreal MouseArea3D::height() const
{
    return m_height;
}

void MouseArea3D::setView3D(QQuick3DViewport *view3D)
{
    if (m_view3D == view3D)
        return;

    m_view3D = view3D;
    emit view3DChanged();
}

void MouseArea3D::setX(qreal x)
{
    if (m_x == x)
        return;

    m_x = x;
    emit xChanged(x);
}

void MouseArea3D::setY(qreal y)
{
    if (m_y == y)
        return;

    m_y = y;
    emit yChanged(y);
}

void MouseArea3D::setWidth(qreal width)
{
    if (m_width == width)
        return;

    m_width = width;
    emit widthChanged(width);
}

void MouseArea3D::setHeight(qreal height)
{
    if (m_height == height)
        return;

    m_height = height;
    emit heightChanged(height);
}

void MouseArea3D::componentComplete()
{
    if (!m_view3D) {
        qmlDebug(this) << "view3D missing!";
        return;
    }
    m_view3D->setAcceptedMouseButtons(Qt::LeftButton);
    m_view3D->setAcceptHoverEvents(true);
    m_view3D->setAcceptTouchEvents(false);
    m_view3D->installEventFilter(this);
}

QVector3D lineIntersectPlane(const QVector3D &linePos0, const QVector3D &linePos1, const QVector3D &planePos, const QVector3D &planeNormal)
{
    QVector3D lineDirection = linePos1 - linePos0;
    QVector3D linePos0RelativeToPlane = linePos0 - planePos;

    float dotLineDirection = QVector3D::dotProduct(planeNormal, lineDirection);
    float dotLinePos0 = -QVector3D::dotProduct(planeNormal, linePos0RelativeToPlane);

    if (qFuzzyIsNull(dotLineDirection)) {
        // Line is parallel to plane. If N == 0 it  means that the
        // line lies in plane. Otherwise, no intersection.
        return QVector3D();
    }

    // If we treat the ray as a line segment (with a start and end), distanceFromLinePos0ToPlane
    // must be between 0 and 1. Otherwise the line will not be long enough to intersect the plane.
    // But a ray only has a fixed start, but no end, so we don't check for that here. Note also
    // that a line is different from a ray in that it has no fixed start either.
    float distanceFromLinePos0ToPlane = dotLinePos0 / dotLineDirection;
    return linePos0 + distanceFromLinePos0ToPlane * lineDirection;
}

bool MouseArea3D::eventFilter(QObject *, QEvent *event)
{
    auto const node = static_cast<QQuick3DNode *>(parent());
    auto const me = static_cast<QMouseEvent *>(event);

    switch (event->type()) {
    case QEvent::HoverMove: {
        if (s_mouseGrab && s_mouseGrab != this)
            break;

        const QVector3D mousePos1(me->pos().x(), me->pos().y(), 0);
        const QVector3D mousePos2(me->pos().x(), me->pos().y(), 1);
        const QVector3D rayPos0 = m_view3D->mapTo3DScene(mousePos1);
        const QVector3D rayPos1 = m_view3D->mapTo3DScene(mousePos2);

        const QVector3D globalPosition = node ? node->mapToGlobal(QVector3D(0, 0, 0)) : QVector3D(0, 0, 0);
        const QVector3D globalPlaneNormal(0, 0, -1); // must transform to global, but not scaled
        const QVector3D intersectPos = lineIntersectPlane(rayPos0, rayPos1, globalPosition, globalPlaneNormal);
        const QVector3D planePos = node->mapFromGlobal(intersectPos);

        const bool mouseOnTopOfPoint =
                planePos.x() >= m_x &&
                planePos.x() <= m_x + m_width &&
                planePos.y() >= m_y &&
                planePos.y() <= m_y + m_height;

        qDebug() << planePos << mouseOnTopOfPoint;
        const bool buttonPressed = QGuiApplication::mouseButtons().testFlag(Qt::LeftButton);

        // The filter will detect a mouse press on the view, but not a mouse release, since the
        // former is not accepted by the view, which means that the release will end up being
        // sent elsewhere. So we need this extra logic inside HoverMove, rather than in
        // MouseButtonRelease, which would be more elegant.

        if (!mouseOnTopOfPoint && m_hovering) {
            m_hovering = false;
            emit hoveringChanged();
        } else if (mouseOnTopOfPoint && !s_mouseGrab) {
            m_hovering = true;
            emit hoveringChanged();
        }

        if (!m_dragging && m_hovering && buttonPressed) {
            m_lastMousePos = me->pos();
            m_dragging = true;
            emit draggingChanged();
        } else if (m_dragging && !buttonPressed) {
            m_dragging = false;
            emit draggingChanged();
        }

        s_mouseGrab = m_hovering || m_dragging ? this : nullptr;

        if (m_dragging) {
            qreal deltaX = me->pos().x() - m_lastMousePos.x();
            qreal deltaY = me->pos().y() - m_lastMousePos.y();
            qreal delta = qSqrt(qPow(deltaX, 2) + qPow(deltaY, 2));
            m_lastMousePos = me->pos();
            emit dragMoved(delta, deltaX, deltaY);
        }
        break; }
    default:
        break;
    }

    return false;
}

#include "moc_mousearea3d.cpp"

QT_END_NAMESPACE
