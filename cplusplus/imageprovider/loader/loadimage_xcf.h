/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef LOADIMAGE_XCF_H
#define LOADIMAGE_XCF_H

#include <QProcess>
#include <QDir>
#include <QSize>
#include <QString>
#include <QTextStream>
#include <QImageReader>
#include "../../logger.h"
#include "errorimage.h"

class LoadImageXCF {

public:

	LoadImageXCF() { }

	QImage load(QString filename, QSize maxSize) {

		QSize origSize;

		// We first check if xcftools is actually installed
		QProcess which;
		which.setStandardOutputFile(QProcess::nullDevice());
		which.start("which xcf2png");
		which.waitForFinished();
		// If it isn't -> display error
		if(which.exitCode()) {
			LOG << CURDATE << "LoadImageXCF: reader xcf - Error: xcftools not found" << NL;
			return ErrorImage::load("PhotoQt relies on 'xcftools'' to display XCF images, but it wasn't found!");
		}

		// Convert xcf to png using xcf2png (part of xcftools)
		QProcess p;
		p.execute(QString("xcf2png \"%1\" -o %2").arg(filename).arg(QDir::tempPath() + "/photoqt_tmp.png"));

		// And load it
		QImageReader reader(QDir::tempPath() + "/photoqt_tmp.png");

		origSize = reader.size();

		int dispWidth = origSize.width();
		int dispHeight = origSize.height();

		double q;

		if(dispWidth > maxSize.width()) {
				q = maxSize.width()/(dispWidth*1.0);
				dispWidth *= q;
				dispHeight *= q;
		}

		// If thumbnails are kept visible, then we need to subtract their height from the absolute height otherwise they overlap with the main image
		if(dispHeight > maxSize.height()) {
			q = maxSize.height()/(dispHeight*1.0);
			dispWidth *= q;
			dispHeight *= q;
		}

		reader.setScaledSize(QSize(dispWidth,dispHeight));

		return reader.read();

	}

};


#endif // LOADIMAGE_XCF_H
