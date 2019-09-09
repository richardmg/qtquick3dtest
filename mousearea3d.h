#ifndef MOUSEAREA3D
#define MOUSEAREA3D

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

class Q_QUICK3D_EXPORT MouseArea3D : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_PROPERTY(QQuick3DViewport *view3D READ view3D WRITE setView3D NOTIFY view3DChanged)
    Q_PROPERTY(qreal x READ x WRITE setX NOTIFY xChanged)
    Q_PROPERTY(qreal y READ y WRITE setY NOTIFY yChanged)
    Q_PROPERTY(qreal width READ width WRITE setWidth NOTIFY widthChanged)
    Q_PROPERTY(qreal height READ height WRITE setHeight NOTIFY heightChanged)
    Q_PROPERTY(bool hovering READ hovering NOTIFY hoveringChanged)
    Q_PROPERTY(bool dragging READ dragging NOTIFY draggingChanged)

    Q_INTERFACES(QQmlParserStatus)

public:
    MouseArea3D(QQuick3DNode *parent = nullptr);

    QQuick3DViewport *view3D() const;

    qreal x() const;
    qreal y() const;
    qreal width() const;
    qreal height() const;

    bool hovering() const;
    bool dragging() const;

public slots:
    void setView3D(QQuick3DViewport *view3D);

    void setX(qreal x);
    void setY(qreal y);
    void setWidth(qreal width);
    void setHeight(qreal height);

    Q_INVOKABLE QVector3D rayIntersectsPlane(const QVector3D &rayPos0, const QVector3D &rayPos1, const QVector3D &planePos, const QVector3D &planeNormal) const;

signals:
    void view3DChanged();

    void xChanged(qreal x);
    void yChanged(qreal y);
    void widthChanged(qreal width);
    void heightChanged(qreal height);

    void hoveringChanged();
    void draggingChanged();
    void pressed(const QVector3D &pointerPosition);
    void released(const QVector3D &pointerPosition);
    void dragged(const QVector3D &pointerPosition);

protected:
    void classBegin() override {}
    void componentComplete() override;
    bool eventFilter(QObject *obj, QEvent *event) override;

private:
    Q_DISABLE_COPY(MouseArea3D)
    QQuick3DViewport *m_view3D = nullptr;

    qreal m_x;
    qreal m_y;
    qreal m_width;
    qreal m_height;

    bool m_hovering = false;
    bool m_dragging = false;

    QVector3D getMousePosInPlane(const QPointF mousePosInView) const;

private:
    static MouseArea3D *s_mouseGrab;
};

QT_END_NAMESPACE

QML_DECLARE_TYPE(MouseArea3D)

#endif // MOUSEPOINT3D
