#ifndef VIEWER_H__
#define VIEWER_H__

#include "MyItem.h"
#include <CGAL/IO/Polyhedron_iostream.h>

#include <iostream>
#include <fstream>

#include <QGLViewer/qglviewer.h>

class Viewer : public QGLViewer
{
	Q_OBJECT

signals:
	void vertsPicked(QString &str);
public slots:
	void invertFace();
	void invertNormal();
	void showWhole();
	void showScalar();
	void computeShortestDistance();

public :
	Viewer(QWidget *parent);
	bool openMesh(const QString &fileName);
protected :
	virtual void init();
	virtual void draw();
	virtual void drawWithNames();
	virtual void postSelection(const QPoint& point);
	virtual void keyPressEvent(QKeyEvent *e);
	virtual QString helpString() const;
private:
private:
	Polyhedron mesh_;
	std::list<Polyhedron::Vertex_iterator> pickedVertices_;
	bool wireframe_;
	bool frontFace_;
	bool flatShading_;
	double pointSize_;
	bool showScalar_;
	double scalarRange_[2];
};

#endif