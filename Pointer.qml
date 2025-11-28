import QtQuick 2.15

Item {      //踏板开度指针
    id:pointer
    property int value: 0
    Rectangle {  //水平矩形
        id: horizontalRectangle
        width:90
        height: 3
        color: "red"
        Rectangle {  //垂直矩形
            id: verticalRectangle
            width: 3
            height: 13
            color: "red"
            anchors.centerIn: horizontalRectangle
        }
    }

    y:value*(450+120)/100

    Behavior on y{
       SmoothedAnimation { velocity: 50 } //NumberAnimation { duration: 500 }
    }
}
