#ifndef LOADIMAGE_RAW_H
#define LOADIMAGE_RAW_H

#include <QImage>
#include <QtDebug>
#include <libraw/libraw.h>

class LoadImageRaw {

public:

	static QImage load(QString filename, QSize maxSize) {

		bool thumb = (maxSize.width() <= 256 && maxSize.height() <= 256);
		bool half = (maxSize.width() <= 1000 && maxSize.height() <= 1000 && !thumb);

		LibRaw raw;
		QByteArray imgData;

		if(half)
			raw.imgdata.params.half_size = 1;

		int ret = raw.open_file((const char*)(QFile::encodeName(filename)).constData());

		if(ret != LIBRAW_SUCCESS) {
			qDebug() << "LibRaw: failed to run open_file: " << libraw_strerror(ret);
			raw.recycle();
			return QImage();
		} else
			qDebug() << "LibRaw: succesfully executed open_file";

		// If an embedded thumbnail is not available -> work around by loading half-size image
		if(thumb && raw.imgdata.thumbnail.tformat == LIBRAW_THUMBNAIL_UNKNOWN) {
			thumb = false;
			half = true;
			raw.imgdata.params.half_size = 1;
		}

		if(thumb)
			ret = raw.unpack_thumb();
		else
			ret = raw.unpack();

		if(ret != LIBRAW_SUCCESS) {
			qDebug() << "LibRaw: failed to run unpack: " << libraw_strerror(ret);
			raw.recycle();
			return QImage();
		} else
			qDebug() << "LibRaw: succesfully executed unpack";

		if(!thumb)
			ret = raw.dcraw_process();

		if (ret != LIBRAW_SUCCESS) {
			qDebug() << "LibRaw: failed to run dcraw_process: " << libraw_strerror(ret);
			raw.recycle();
			return QImage();
		} else
			qDebug() << "LibRaw: succesfully executed dcraw_process";

		libraw_processed_image_t* img;
		if(thumb)
			img = raw.dcraw_make_mem_thumb(&ret);
		else
			img = raw.dcraw_make_mem_image(&ret);



		// createPPMHeader()
		QString header = QString::fromUtf8("P%1\n%2 %3\n%4\n")
				.arg(img->colors == 3 ? QLatin1String("6") : QLatin1String("5"))
				.arg(img->width)
				.arg(img->height)
				.arg((1 << img->bits)-1);
		imgData.append(header.toLatin1());
		imgData.append(QByteArray((const char*)img->data, (int)img->data_size));

		if(imgData.isEmpty()) {
			qDebug() << "Failed to load half preview from LibRaw!";
			return QImage();
		}

		QImage image/*(width, height, QImage::Format_ARGB32)*/;

		if(!image.loadFromData(imgData)) {
			qDebug() << "Failed to load PPM data from LibRaw!";
			return QImage();
		}

		return image;

	}

};


#endif // LOADIMAGE_RAW_H