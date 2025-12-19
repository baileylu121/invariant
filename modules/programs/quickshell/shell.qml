import Quickshell
import Quickshell.Io
import QtQuick

import "root:/Modules"

ShellRoot {
    id: root

    SystemPalette {
        id: theme
        colorGroup: SystemPalette.Active
    }

    LazyLoader {
        active: true
        component: Bar {}
    }

    LazyLoader {
        active: true
        component: Background {}
    }
}
