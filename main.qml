import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls
import MqttClient





Window {
    width: 1300
    height: 650
    visible: true
    title: qsTr("LingYunE20")
    color: "#000000"
    //加载字体
    FontLoader {
        id: localFont
        source: "big-numbers.ttf"
    } //仪表数字显示使用字体



    FontLoader {
        id: ffzont
        source: "TTZhiHeiJ-W4.ttf"
    }

    MqttClient{
        id:carclient
        carSpeed: 0     //车速
        batLevel: 0     //电池剩余电量百分比
        batcur:  0      //电池放电电流
        throPos: 0      //油门开度
        batVol: 0       //电池箱电压
        mcu1Temp: 0     //电机控制器1温度
        mcu2Temp: 0     //电机控制器2温度
        carDistance: 0  //赛车行驶的距离
        brakeTravel: 0  //制动踏板开度
        lmotorTemp: 0   //左电机温度
        rmotorTemp: 0   //右电机温度D
        lmotorSpeed: 0  //左电机转速度
        rmotorSpeed: 0  //右电机转速
        angle: 45       //方向盘角度
        acc_x: 0.0      //x轴加速度
        acc_y: 0        //y轴加速度
        acc_z:  0.0     //z轴加速度
        yaw: 0.00       //偏航角速度
    }







    //左半部分(break)  因为有一个矩形用来看画布大小所以一定把此项目放在最下层
    Item {
        id: id_breakroot
        x:0; y:40
        width: 1300
        height: 570
        property int value: 0
        // Rectangle {        //调整颜色看画布大小
        //     id: id_speed
        //     anchors.centerIn: parent
        //     height: parent.height
        //     width: parent.width
        //     color: "black"
            Canvas {          //画弧线与直线
                id:canvas
                anchors.fill: parent
                contextType: "2d"
                rotation: 0
                antialiasing: true
                onPaint: {
                    //弧形
                    var context = canvas.getContext('2d');           //重要定义绘画的对象
                    context.strokeStyle = "white";
                    context.lineWidth = parent.height * 0.008;
                    context.beginPath();
                    context.arc(width/ 2, height/ 2, height/1.6, 0, Math.PI * 2, false);//（y，x）
                    context.stroke();

                    //框线
                    var gradient3 = context.createLinearGradient(0, 120, width/2-316, 120);//定义了渐变的起点x,y和终点坐标x,y
                    gradient3.addColorStop(0, 'black');   // 起点颜色为黑色
                    gradient3.addColorStop(1, 'white');  // 终点颜色为白色
                    context.strokeStyle = gradient3; // 设置线条样式
                    context.lineWidth = 7;
                    context.beginPath(); // 开始路径
                    context.moveTo(0, 120);
                    context.lineTo(width/2-316, 120); // 到达画布左侧侧结束
                    context.stroke(); // 描绘路径
                    var gradient4 = context.createLinearGradient(0, 448, width/2-316, 448);//定义了渐变的起点x,y和终点坐标x,y
                    gradient4.addColorStop(0, 'black');   // 起点颜色为黑色
                    gradient4.addColorStop(1, 'white');   // 终点颜色为白色
                    context.strokeStyle = gradient4;// 设置线条样式
                    context.lineWidth = 7;
                    context.beginPath();// 开始路径
                    context.moveTo(0, 448);
                    context.lineTo(width/2-316, 448); // 到达画布左侧
                    context.stroke(); // 描绘路径

                    //压力刻度线
                    context.setLineDash([0.23,0.48]);
                    /*数组的第一个元素表示实线段的长度。数组的第二个元素表示空白段的长度。
                    数组的第三个元素（如果存在）再次表示实线段的长度，依此类推*/
                    context.strokeStyle = "white";
                    context.lineWidth = 13;
                    context.beginPath();
                    context.moveTo(width/2-216, 120); // 起点
                    context.lineTo(width/2-216, 450); // 终点
                    context.stroke();

                    //刻度线边界
                    context.strokeStyle = "white"; // 线条颜色
                    context.lineWidth = 25; // 线条宽度
                    context.beginPath();
                    context.moveTo(width/2-221, 115); // 起点
                    context.lineTo(width/2-221, 118); // 终点
                    context.stroke();
                    context.strokeStyle = "white"; // 线条颜色
                    context.lineWidth = 25; // 线条宽度
                    context.beginPath();
                    context.moveTo(width/2-221, 451); // 起点
                    context.lineTo(width/2-221, 454); // 终点
                    context.stroke();
                }
            }

            Label{
                x: canvas.width/2-259.5
                y: 107
                color: "white"
                text:"100"
                font.pointSize: 10
                font.family: "Comic Sans MS"
            }

            Pointer{         //制动踏板指针
                id: id_BrakePedal_Pointer
                anchors.right: id_breakroot.right
                anchors.rightMargin:948
                y:285
                value: carclient.brakeTravel
            }
        //}
    }







    //右半部分(acc)  因为有一个矩形用来看画布大小所以一定把此项目放在最下层
    Item {
        id: id_accroot
        x:0; y:40
        width: 1300
        height: 570
        property int value: 0
        // Rectangle {        //调整颜色看画布大小
        //     id: id_speed
        //     anchors.centerIn: parent
        //     height: parent.height
        //     width: parent.width
        //     color: "black"
            Canvas {             //画线
                id:canvas2
                anchors.fill: parent
                contextType: "2d"
                rotation: 0
                antialiasing: true
                onPaint: {
                    //框线
                    var context = canvas2.getContext('2d');         //重要定义绘画的对象
                    var gradient1 = context.createLinearGradient(width/2+316, 120, width, 120);//定义了渐变的起点x,y和终点坐标x,y
                    gradient1.addColorStop(0, 'white');   // 起点颜色为白色
                    gradient1.addColorStop(1, 'black');  // 终点颜色为黑色
                    context.strokeStyle = gradient1;// 设置线条样式
                    context.lineWidth = 7;
                    context.beginPath(); // 开始路径
                    context.moveTo(width/2+316, 120);
                    context.lineTo(width, 120); // 到达画布右侧结束
                    context.stroke(); // 描绘路径
                    var gradient2 = context.createLinearGradient(width/2+316, 448, width, 448);//定义了渐变的起点x,y和终点坐标x,y
                    gradient2.addColorStop(0, 'white');   // 起点颜色为白色
                    gradient2.addColorStop(1, 'black');   // 终点颜色为黑色
                    context.strokeStyle = gradient2; // 设置线条样式
                    context.lineWidth = 7;
                    context.beginPath(); // 开始路径
                    context.moveTo(width/2+316, 448);
                    context.lineTo(width, 448); // 到达画布右侧
                    context.stroke(); // 描绘路径

                    //开度刻度线
                    context.setLineDash([0.23,0.48]);
                    /*数组的第一个元素表示实线段的长度。数组的第二个元素表示空白段的长度。
                    数组的第三个元素（如果存在）再次表示实线段的长度，依此类推*/
                    context.strokeStyle = "white";
                    context.lineWidth = 13;
                    context.beginPath();
                    context.moveTo(width/2+214, 120); // 起点
                    context.lineTo(width/2+214, 450); // 终点
                    context.stroke();

                    //刻度线边界
                    context.strokeStyle = "white"; // 线条颜色
                    context.lineWidth = 24; // 线条宽度
                    context.beginPath();
                    context.moveTo(width/2+219, 115); // 起点
                    context.lineTo(width/2+219, 118); // 终点
                    context.stroke();
                    context.strokeStyle = "white"; // 线条颜色
                    context.lineWidth = 24; // 线条宽度
                    context.beginPath();
                    context.moveTo(width/2+219, 451); // 起点
                    context.lineTo(width/2+219, 454); // 终点
                    context.stroke();
                }
            }

            Label{
                x: canvas.width/2+235
                y: 107
                color: "white"
                text:"100"
                font.pointSize: 10
                font.family: "Comic Sans MS"
            }

            Pointer{         //加速踏板指针
                id: id_AcceleratorPedal_Pointer
                anchors.left: id_accroot.left
                anchors.leftMargin:canvas.width/2+207
                y:285
                value: carclient.throPos
            }
        //}
    }









    //队标图片（彩彩的蛋未完成）
    Image {
        id: logo
        source: "qrc:/lingyun.png"
        x: 20; y:20
        width: sourceSize.width/9.5
        height: sourceSize.height/9.5
        Component.onCompleted: console.log(sourceSize);
    }








    //连接标志
    Item {
        id:mqttindicator
        x:1248; y:15
        Rectangle{
            id:connect
            width:30
            height: 30
            color:"#333333"
            radius: 100
        }

        Label{
            id:mqttlabel
            y:35
            width: 30
            height: 10
            color: "#E4080A"
            text: "MQTT"
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 9
        }
    }








    //SOC
    Item {
        id: soc_label
        x: 590
        y: 540
        width: 100
        height: 100
        Loader {
            id: socLoader
            anchors.centerIn: parent
            sourceComponent: {
                if (carclient.batLevel===100) {
                    return soc_100;
                } else if (carclient.batLevel<100 && carclient.batLevel>=10) {
                    return soc_10;
                } else {
                    return soc_1;
                }
            }
        }
        Component {
            id: soc_100
            Text {
                x:-10
                color: "white"
                text: "1"
                font.family: "big-numbers"
                font.pixelSize: 35
                Text {
                    color: "white"
                    text: "0"
                    font.family: "big-numbers"
                    font.pixelSize: 35
                    anchors.left: parent.right
                    anchors.leftMargin: -10
                    anchors.top: parent.top
                    Text {
                        color: "white"
                        text: "0"
                        font.family: "big-numbers"
                        font.pixelSize: 35
                        anchors.left: parent.right
                        anchors.leftMargin: -10
                        anchors.top: parent.top
                        Text {
                            color: "#E22424"
                            text: qsTr("SOC")
                            font.family: "Tensentype ZhiHeiJ-W4"
                            font.pixelSize: 20
                            anchors.left: parent.left
                            anchors.leftMargin: -25
                            anchors.top: parent.bottom
                            anchors.topMargin:4
                        }
                    }
                }
            }
        }
        Component {
            id: soc_10
            Text {
                color: "white"
                text: parseInt(carclient.batLevel / 10 % 10)
                font.family: "big-numbers"
                font.pixelSize: 35
                Text {
                    color: "white"
                    text: parseInt(carclient.batLevel % 10)
                    font.family: "big-numbers"
                    font.pixelSize: 35
                    anchors.left: parent.right
                    anchors.leftMargin: -10
                    anchors.top: parent.top
                    Text {
                        color: "#E22424"
                        text: qsTr("SOC")
                        font.family: "Tensentype ZhiHeiJ-W4"
                        font.pixelSize: 20
                        anchors.left: parent.left
                        anchors.leftMargin: -13
                        anchors.top: parent.bottom
                        anchors.topMargin:4
                    }
                }
            }
        }
        Component {
            id: soc_1
            Text {
                x:13
                color: "white"
                text: carclient.batLevel
                font.family: "big-numbers"
                font.pixelSize: 35
                Text {
                    color: "#E22424"
                    text: qsTr("SOC")
                    font.family: "Tensentype ZhiHeiJ-W4"
                    font.pixelSize: 20
                    anchors.left: parent.left
                    anchors.top: parent.bottom
                    anchors.topMargin:4
                }
            }
        }
    }









    //车速
    Item{
        id:carSpeed_label
        x:300
        y:125
        width:600
        height:400
        Loader {
            id: textLoader
            anchors.centerIn: parent
            sourceComponent: {
                if (carclient.carSpeed<10&& carclient.carSpeed!=0) {
                    return text_1;
                } else if (carclient.carSpeed<100 && carclient.carSpeed>=10) {
                    return text_10;
                } else if ( carclient.carSpeed>=100 ) {
                    return text_100;
                } else {
                    return p;
                }
            }
        }
        Component {
            id: text_100
            Text {
                x:-70
                color: "white"
                text: parseInt(carclient.carSpeed /100 %10)
                font.family: "big-numbers"
                font.pixelSize: 180
                Text {
                    color: "white"
                    text: parseInt(carclient.carSpeed /10 %10)
                    font.family: "big-numbers"
                    font.pixelSize: 180
                    anchors.left: parent.right
                    anchors.leftMargin: -58
                    anchors.top: parent.top
                    Text {
                        color: "white"
                        text: parseInt(carclient.carSpeed % 10)
                        font.family: "big-numbers"
                        font.pixelSize: 180
                        anchors.left: parent.right
                        anchors.leftMargin: -58
                        anchors.top: parent.top
                    }
                }
            }
        }
        Component {
            id: text_10
            Text {
                x:-7
                color: "white"
                text: parseInt(carclient.carSpeed /10 %10)
                font.family: "big-numbers"
                font.pixelSize: 180
                Text {
                    color: "white"
                    text: parseInt(carclient.carSpeed % 10)
                    font.family: "big-numbers"
                    font.pixelSize: 180
                    anchors.left: parent.right
                    anchors.leftMargin: -58
                    anchors.top: parent.top
                }
            }
        }
        Component {
            id: text_1
            Text {
                x:52
                color: "white"
                text: parseInt(carclient.carSpeed)
                font.family: "big-numbers"
                font.pixelSize: 180
            }
        }
        Component {
            id: p
            Text {
                x:52
                color: "white"
                text: "P"
                font.pixelSize: 180
            }
        }
    }






    //左电机转速
    Item{
        id:lmotorspeed_label
        x:0
        y:135
        width:300
        height:200
        Text{
            id:lmotorspeed_1000
            x:22; y:70
            color:"white"
            text: parseInt(carclient.lmotorSpeed /1000 %10)
            font.family: "big-numbers"
            font.pixelSize: 32
        }
        Text{
            id:lmotorspeed_100
            color:"white"
            text: carclient.lmotorSpeed / 100 %10
            font.family: "big-numbers"
            font.pixelSize: 32
            anchors.left: lmotorspeed_1000.right
            anchors.leftMargin:-7
            anchors.top: lmotorspeed_1000.top
        }
        Text{
            id:lmotorspeed_10
            color:"white"
            text: parseInt(carclient.lmotorSpeed /10 %10)
            font.family: "big-numbers"
            font.pixelSize: 32
            anchors.left: lmotorspeed_100.right
            anchors.leftMargin:-7
            anchors.top: lmotorspeed_100.top
        }
        Text{
            id:lmotorspeed_1
            color:"white"
            text: carclient.lmotorSpeed % 10
            font.family: "big-numbers"
            font.pixelSize: 32
            anchors.left: lmotorspeed_10.right
            anchors.leftMargin:-7
            anchors.top: lmotorspeed_10.top
        }
        Text {
            id: lmotorspeed_text
            color: "#E22424"
            text: qsTr("lmotspeed")
            font.family: "Tensentype ZhiHeiJ-W4"
            font.pixelSize: 16
            anchors.top: lmotorspeed_1000.bottom
            anchors.left: lmotorspeed_1000.left
            anchors.leftMargin:17
            anchors.topMargin:2
        }
    }
    //右电机转速
    Item{
        id:rmotorspeed_label
        x:100
        y:135
        width:300
        height:200
        Text{
            id:rmotorspeed_1000
            x:70; y:70
            color:"white"
            text: parseInt(carclient.rmotorSpeed /1000 %10)
            font.family: "big-numbers"
            font.pixelSize: 32
        }
        Text{
            id:rmotorspeed_100
            color:"white"
            text: parseInt(carclient.rmotorSpeed / 100 %10)
            font.family: "big-numbers"
            font.pixelSize: 32
            anchors.left: rmotorspeed_1000.right
            anchors.leftMargin:-7
            anchors.top: rmotorspeed_1000.top
        }
        Text{
            id:rmotorspeed_10
            color:"white"
            text: parseInt(carclient.rmotorSpeed /10 %10)
            font.family: "big-numbers"
            font.pixelSize: 32
            anchors.left: rmotorspeed_100.right
            anchors.leftMargin:-7
            anchors.top: rmotorspeed_100.top
        }
        Text{
            id:rmotorspeed_1
            color:"white"
            text: carclient.rmotorSpeed % 10
            font.family: "big-numbers"
            font.pixelSize: 32
            anchors.left: rmotorspeed_10.right
            anchors.leftMargin:-7
            anchors.top: rmotorspeed_10.top
        }
        Text {
            id: rmotorspeed_text
            color: "#E22424"
            text: qsTr("rmotspeed")
            font.family: "Tensentype ZhiHeiJ-W4"
            font.pixelSize: 16
            anchors.top: rmotorspeed_1000.bottom
            anchors.left: rmotorspeed_1000.left
            anchors.leftMargin:17
            anchors.topMargin:2
        }
    }










    //电机控制器1温度
    Item {
        id: mcu1TempLabel
        x:1020
        y:110
        width:300
        height:200
        Text {
            id: mcu1Temp_10
            x:30; y: 70
            color:"white"
            text: parseInt(carclient.mcu1Temp / 10 % 10)
            font.family: "big-numbers"
            font.pixelSize: 30
        }
        Text {
            id: mcu1Temp_1
            color:"white"
            text: parseInt(carclient.mcu1Temp % 10)
            font.family: "big-numbers"
            font.pixelSize: 30
            anchors.left: mcu1Temp_10.right
            anchors.leftMargin:-7
            anchors.top: mcu1Temp_10.top
        }
        Text {
            id: mcu1Temp_text
            color: "#E22424"
            text: qsTr("MCU1Temp")
            font.family: "Tensentype ZhiHeiJ-W4"
            font.pixelSize: 12
            anchors.top: mcu1Temp_10.bottom
            anchors.left: mcu1Temp_10.left
            anchors.topMargin:2
        }
    }
    //电机控制器2温度
    Item {
        id: mcu2TempLabel
        x:1080
        y:110
        width: 100
        height: 100
        Text {
            id: mcu2Temp_10
            x: 90; y: 70
            color:"white"
            text: parseInt(carclient.mcu2Temp % 10)
            font.family: "big-numbers"
            font.pixelSize: 30
        }
        Text {
            id: mcu2Temp_1
            color:"white"
            text: parseInt(carclient.mcu2Temp % 10)
            font.family: "big-numbers"
            font.pixelSize: 30
            anchors.left: mcu2Temp_10.right
            anchors.leftMargin:-7
            anchors.top: mcu2Temp_10.top
        }
        Text {
            id: mcu2Temp_text
            color: "#E22424"
            text: qsTr("MCU2Temp")
            font.family: "Tensentype ZhiHeiJ-W4"
            font.pixelSize: 12
            anchors.top: mcu2Temp_10.bottom
            anchors.left: mcu2Temp_10.left
            anchors.topMargin:2
        }
    }









    //左电机温度
    Item {
        id:lmoTempLabel
        x: 980
        y: 240
        width: 100
        height: 100
        Text {
            id: lmoTemp_10
            x: 70
            y: 0
            color:"white"
            text: parseInt(carclient.lmotorTemp / 10 % 10)
            font.family: "big-numbers"
            font.pixelSize: 30
        }
        Text {
            id: lmoTemp_1
            color:"white"
            text: parseInt(carclient.lmotorTemp % 10)
            font.family: "big-numbers"
            font.pixelSize: 30
            anchors.left: lmoTemp_10.right
            anchors.leftMargin:-7
            anchors.top: lmoTemp_10.top
        }
        Text {
            id: lmoTemp_text
            color: "#E22424"
            text: qsTr("lmoTemp")
            font.family: "Tensentype ZhiHeiJ-W4"
            font.pixelSize: 14
            anchors.top: lmoTemp_10.bottom
            anchors.left: lmoTemp_10.left
            anchors.leftMargin:1
            anchors.topMargin:2
        }
    }
    //右电机温度
    Item {
        id:rmoTempLabel
        x: 1080
        y: 240
        width: 100
        height: 100
        Text {
            id: rmoTemp_10
            x: 90
            y: 0
            color:"white"
            text: parseInt(carclient.rmotorTemp / 10 % 10)
            font.family: "big-numbers"
            font.pixelSize: 30
        }
        Text {
            id: rmoTemp_1
            color:"white"
            text: parseInt(carclient.rmotorTemp % 10)
            font.family: "big-numbers"
            font.pixelSize: 30
            anchors.left: rmoTemp_10.right
            anchors.leftMargin:-7
            anchors.top: rmoTemp_10.top
        }
        Text {
            id: rmoTemp_text
            color: "#E22424"
            text: qsTr("lmoTemp")
            font.family: "Tensentype ZhiHeiJ-W4"
            font.pixelSize: 14
            anchors.top: rmoTemp_10.bottom
            anchors.left: rmoTemp_10.left
            anchors.topMargin:2
        }
    }











    //加速度仪表
    Item {
        id:accelerate
        x:1055; y:301.5
        width: 170
        height: 170
        Rectangle{
            id:acceleratedash
            color:"#333333"
            anchors.centerIn: parent
            anchors.fill: parent
            radius: width/2
            Rectangle{
                anchors.centerIn: parent
                width: parent.width-10
                height: parent.height-10
                radius: width/2
                color: "#333333"
                border.color: "white"
                border.width: 2
            }
        }
        Canvas{
            id:acceleratecanvas
            anchors.fill: parent
            contextType: "2d"
            onPaint: {
                var cav = getContext("2d");
                cav.strokeStyle = "white"
                cav.lineWidth = 0.5

                cav.moveTo(parent.width/2, parent.height/2)
                cav.beginPath()
                cav.arc(parent.width/2,parent.height/2,60,0,Math.PI * 2,true)
                cav.stroke()

                cav.beginPath()
                cav.arc(parent.width/2,parent.height/2,40,0,Math.PI * 2,true)
                cav.stroke()

                cav.beginPath()
                cav.arc(parent.width/2,parent.height/2,20,0,Math.PI *2,true)
                cav.stroke()
            }
        }
        Rectangle{
            id:indicator  //指示器
            width: 7
            height: width
            x:(parent.width/2 -3) +carclient.acc_y * 40
            y:(parent.width/2 -3) +carclient.acc_x * 40
            color:"red"
            radius: width/2
        }
    }










    //时间
    Item{
        x:35; y:601
        width: 10
        height: 50
        Text {
            id: time
            font.pointSize: 24
            color:"#8C8C97"
            font.family: "Tensentype ZhiHeiJ-W4"
        }
        Timer{
            id:timer
            interval: 1000; running: true; repeat: true
            onTriggered: time.text = Qt.formatDateTime(new Date(),"hh-mm--ss")
        }
        Component.onCompleted: {
            timer.start()
        }
    }









    //accx
    Item{
        id:accxNum
        x: 0
        y: 295
        width: 100
        height: 100
        Text {
            id: accx_10
            x: 18; y: 5
            color: "white"
            text: carclient.acc_x.toFixed(2)
            font.family: "big-numbers"
            font.pixelSize: 35

        }
        Text {
            id: accx
            color: "#E22424"
            text: qsTr("accx")
            font.family: "Tensentype ZhiHeiJ-W4"
            font.pixelSize: 18
            anchors.top: accx_10.bottom
            anchors.left: accx_10.left
            anchors.leftMargin:38
            anchors.topMargin:-7
        }
    }
    //accy
    Item{
        id:accyNum
        x: 100
        y: 295
        width: 100
        height: 100
        Text {
            id: accy_10
            x: 65; y: 5
            color: "white"
            text: carclient.acc_y.toFixed(2)
            font.family: "big-numbers"
            font.pixelSize: 35
        }
        Text {
            id: accy
            x: 2
            y: 56
            color: "#E22424"
            text: qsTr("accy")
            font.family: "Tensentype ZhiHeiJ-W4"
            font.pixelSize: 18
            anchors.top: accy_10.bottom
            anchors.left: accy_10.left
            anchors.leftMargin:38
            anchors.topMargin:-7
        }
    }
    //accz
    Item{
        id:acczNum
        x: 0; y: 390
        width: 100
        height:  100
        Text {
            id: accz_10
            x: 18; y: 0
            color: "white"
            text: carclient.acc_z.toFixed(2)
            font.family: "big-numbers"
            font.pixelSize: 35
        }
        Text {
            id: accz
            color: "#E22424"
            text: qsTr("accz")
            font.family: "Tensentype ZhiHeiJ-W4"
            font.pixelSize: 18
            anchors.top: accz_10.bottom
            anchors.left: accz_10.left
            anchors.leftMargin:38
            anchors.topMargin:-7
        }
    }
    //yaw
    Item{
        id:yawNum
        x: 100; y: 390
        width: 100
        height:  100
        Text {
            id: yaw_10
            x: 65; y: 0
            color: "white"
            text: carclient.batcur.toFixed(2)
            font.family: "big-numbers"
            font.pixelSize: 35
        }
        Text {
            id: yaw
            color: "#E22424"
            text: qsTr("yaw")
            font.family: "Tensentype ZhiHeiJ-W4"
            font.pixelSize: 18
            anchors.top: yaw_10.bottom
            anchors.left: yaw_10.left
            anchors.leftMargin:38
            anchors.topMargin:-7
        }
    }









    //角度指示器
    Item {
        id: angle
        x:15; y:503
        Label{
            text: "steering wheel angle"
            font.pixelSize: 15
            font.family: "Tensentype ZhiHeiJ-W4"
            color: "#E22424"
        }
        Anglesensor{
            y:angle.parent.y + 15
            width: 295
            height: 20
            z:1
            value: carclient.angle + 90
        }
    }








    //模式
    Item {
        id: model
        x:580; y:70
        Text {
            color: "white"
            text: qsTr("MODEL")
            font.family: "Tensentype ZhiHeiJ-W4"
            font.pixelSize: 45
        }
    }






    //连接按钮
    Button{
        id:connectbut
        x:1090; y:610
        width: 80
        height: 20
        flat: false
        text: carclient.state === MqttClient.Connected ? "Disconnect" : "Connect"
        onClicked: {
            if(carclient.state === MqttClient.Connected){
                carclient.disconnectFromHost()
                connect.color = "#333333"
            }
            else{
                carclient.connectToHost()
                connect.color = "red"
                subscribebut.enabled = true
                publishbut.enabled = true
            }
        }
    }

    //订阅按钮
    Button{
        id: subscribebut
        x:1190; y:610
        width: 80
        height: 20
        flat: false
        text: "subscribe"
        enabled: false
        onClicked: {
            carclient.subscribe("qtmqtt/topic1")//"mqtt"
            subscribebut.enabled = false
        }

    }

    //发送信息按钮
    Button{
        id: publishbut
        x:990; y:610
        width: 80
        height: 20
        flat: false
        text: "Publish"
        enabled: false
        onClicked: {
            carclient.publishmessage("qtmqtt/topic1")
        }
    }
}
