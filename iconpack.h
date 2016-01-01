#ifndef ICONPACK
#define ICONPACK

#include <QObject>
#include <QDebug>
#include <sys/types.h>
#include <unistd.h>
#include "exec.h"
#include <QFileInfo>
#include <QDir>

class IconPack : public QObject {
    Q_OBJECT
public:
    Q_INVOKABLE QString whoami() const {
        setuid(0);
        return QString::fromStdString(exec("whoami"));
    }

    Q_INVOKABLE QString listIconPacks() const {
        return QString::fromStdString(exec("cd /usr/share/; ls -d harbour-iconpack-* | cut -c18-"));
    }

    Q_INVOKABLE bool apply(const QString name) const {
        std::string c_name = name.toStdString();
        std::string command = "/usr/share/harbour-iconpacksupport-gui/apply.sh "+c_name;
        system(command.c_str());
        return true;
    }

    Q_INVOKABLE bool restore() const {
        system("/usr/share/harbour-iconpacksupport-gui/restore.sh");
        return true;
    }

    Q_INVOKABLE bool hideIcon() const {
        setuid(0);
        system("echo \"NoDisplay=true\" >> /usr/share/applications/harbour-iconpacksupport.desktop");
        return true;
    }
};

#endif // ICONPACK

