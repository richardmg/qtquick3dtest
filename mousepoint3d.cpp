#include "mousepoint3d_p.h"

QT_BEGIN_NAMESPACE

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
    qWarning("Floating point comparison needs context sanity check");
    if (qFuzzyCompare(m_radius, radius))
        return;

    m_radius = radius;
    emit radiusChanged();
}

#include "moc_qquickmousepoint3d_p.cpp"

QT_END_NAMESPACE
