#ifndef MOUSEPOINT3D
#define MOUSEPOINT3D

//
//  W A R N I N G
//  -------------
//
// This file is not part of the Qt API.  It exists purely as an
// implementation detail.  This header file may change from version to
// version without notice, or even be removed.
//
// We mean it.
//

#include <QVector3D>
#include <QtCore/qpointer.h>
#include <QtQuick3D/private/qquick3dnode_p.h>
#include <QtQuick3D/private/qquick3dviewport_p.h>
#include <QtQuick3D/private/qtquick3dglobal_p.h>

QT_BEGIN_NAMESPACE

class Q_QUICK3D_EXPORT MousePoint3D : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_PROPERTY(QQuick3DViewport *view3D READ view3D WRITE setView3D NOTIFY view3DChanged)
    Q_PROPERTY(QVector3D position READ position WRITE setPosition NOTIFY positionChanged)
    Q_PROPERTY(qreal radius READ radius WRITE setRadius NOTIFY radiusChanged)
    Q_PROPERTY(bool hovering READ hovering NOTIFY hoveringChanged)
    Q_PROPERTY(bool dragging READ dragging NOTIFY draggingChanged)

    Q_INTERFACES(QQmlParserStatus)

public:
    MousePoint3D(QQuick3DNode *parent = nullptr);

    QQuick3DViewport *view3D() const;
    QVector3D position() const;
    qreal radius() const;
    bool hovering() const;
    bool dragging() const;

public slots:
    void setView3D(QQuick3DViewport *view3D);
    void setPosition(QVector3D position);
    void setRadius(qreal radius);

signals:
    void view3DChanged();
    void positionChanged();
    void radiusChanged();
    void hoveringChanged();
    void draggingChanged();
    void dragMoved(qreal deltaX, qreal deltaY);

protected:
    void classBegin() override {}
    void componentComplete() override;
    bool eventFilter(QObject *obj, QEvent *event) override;

private:
    Q_DISABLE_COPY(MousePoint3D)
    QQuick3DViewport *m_view3D = nullptr;
    QVector3D m_position;
    qreal m_radius = 20;
    bool m_hovering = false;
    bool m_dragging = false;

    QPoint m_lastMousePos;

    static MousePoint3D *s_mouseGrab;
};

QT_END_NAMESPACE

QML_DECLARE_TYPE(MousePoint3D)

#endif // MOUSEPOINT3D
