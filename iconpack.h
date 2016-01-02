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
    Q_INVOKABLE QString whoami() const { // function to test what user runs app
        setuid(0);
        return QString::fromStdString(exec("whoami"));
    }

    Q_INVOKABLE QString listIconPacks() const { // list all dirs in /usr/share which start with harbour-iconpack- prefix
        return QString::fromStdString(exec("cd /usr/share/; ls -d harbour-iconpack-* | cut -c18-"));
    }

    Q_INVOKABLE bool apply(const QString name) const { // calls apply script, which then runs original application and tells it to apply the icon theme
        std::string c_name = name.toStdString();
        std::string command = "/usr/share/harbour-iconpacksupport-gui/apply.sh "+c_name;
        system(command.c_str());
        return true;
    }

    Q_INVOKABLE bool restore() const { // calls restore script, which runs original application and restores original icon pack
        system("/usr/share/harbour-iconpacksupport-gui/restore.sh");
        return true;
    }

    Q_INVOKABLE bool hideIcon() const { // hides icon of original app, so user does not have to have two same icons on home screen
        setuid(0);
        system("echo \"NoDisplay=true\" >> /usr/share/applications/harbour-iconpacksupport.desktop");
        return true;
    }

    Q_INVOKABLE QString getName(const QString packname) const { // gets name from the package file
        std::string c_packname = packname.toStdString();
        std::string command = "cat /usr/share/harbour-iconpack-"+c_packname+"/package";
        return QString::fromStdString(exec(command.c_str()));
    }
};

#endif // ICONPACK

