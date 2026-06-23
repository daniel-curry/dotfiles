pragma Singleton
import QtQuick

QtObject {
    signal volume(real value, bool muted)
    signal brightness(real value)
}
