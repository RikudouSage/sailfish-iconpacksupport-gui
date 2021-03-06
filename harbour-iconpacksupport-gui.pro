TARGET = harbour-iconpacksupport-gui

MY_FILES = \
other/apply.sh \
other/restore.sh \
other/apply_font.sh \
other/homescreen.sh \
other/restore_fonts.sh

OTHER_SOURCES += $$MY_FILES

my_resources.path = $$PREFIX/share/$$TARGET
my_resources.files = $$MY_FILES

INSTALLS += my_resources

CONFIG += sailfishapp

SOURCES += src/harbour-iconpacksupport-gui.cpp

OTHER_FILES += qml/harbour-iconpacksupport-gui.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-iconpacksupport-gui.changes.in \
    rpm/harbour-iconpacksupport-gui.spec \
    rpm/harbour-iconpacksupport-gui.yaml \
    translations/*.ts \
    harbour-iconpacksupport-gui.desktop \
    qml/js/*.js \
    qml/components/Button.qml

SAILFISHAPP_ICONS = 86x86

CONFIG += sailfishapp_i18n

TRANSLATIONS += translations/harbour-iconpacksupport-gui-cs_CZ.ts
TRANSLATIONS += translations/harbour-iconpacksupport-gui-sv.ts
TRANSLATIONS += translations/harbour-iconpacksupport-gui-fi.ts
TRANSLATIONS += translations/harbour-iconpacksupport-gui-fr.ts

HEADERS += \
    exec.h \
    iconpack.h

DISTFILES += \
    qml/pages/MainPage.qml \
    qml/pages/Confirm.qml \
    qml/pages/Restore.qml \
    qml/pages/About.qml \
    qml/components/Placeholder.qml \
    qml/components/FLabel.qml \
    qml/pages/Uninstall.qml

