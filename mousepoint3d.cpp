﻿#include "mousepoint3d.h"

#include <QtQml>
#include <QGuiApplication>

QT_BEGIN_NAMESPACE

MousePoint3D *MousePoint3D::s_mouseGrab = nullptr;

MousePoint3D::MousePoint3D(QQuick3DNode *parent)
    : QObject(parent)
{
}

QQuick3DViewport *MousePoint3D::view3D() const
{
    return m_view3D;
}

QVector3D MousePoint3D::position() const
{
    return m_position;
}

qreal MousePoint3D::radius() const
{
    return m_radius;
}

bool MousePoint3D::hovering() const
{
    return m_hovering;
}

bool MousePoint3D::dragging() const
{
    return m_dragging;
}

void MousePoint3D::setView3D(QQuick3DViewport *view3D)
{
    if (m_view3D == view3D)
        return;

    m_view3D = view3D;
    emit view3DChanged();
}

void MousePoint3D::setPosition(QVector3D position)
{
    if (m_position == position)
        return;

    m_position = position;
    emit positionChanged();
}

void MousePoint3D::setRadius(qreal radius)
{
    if (qFuzzyCompare(m_radius, radius))
        return;

    m_radius = radius;
    emit radiusChanged();
}

void MousePoint3D::componentComplete()
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

bool MousePoint3D::eventFilter(QObject *, QEvent *event)
{
    auto const node = static_cast<QQuick3DNode *>(parent());
    auto const me = static_cast<QMouseEvent *>(event);

    switch (event->type()) {
    case QEvent::HoverMove: {
        if (s_mouseGrab && s_mouseGrab != this)
            break;

        QVector3D globalPosition = node ? node->mapToGlobal(m_position) : m_position;
        QVector3D viewPosition = m_view3D->mapFrom3DScene(globalPosition);
        qreal dist = qSqrt(qPow(me->pos().x() - viewPosition.x(), 2) + qPow(me->pos().y() - viewPosition.y(), 2));
        bool mouseOnTopOfPoint = dist < m_radius;
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
            m_lastMousePos = me->pos();
            emit dragMoved(deltaX, deltaY);
        }
        break; }
    default:
        break;
    }

    return false;
}

#include "moc_mousepoint3d.cpp"

QT_END_NAMESPACE
