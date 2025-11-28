#include "mqtttest.h"
#include <QDebug>


extern int attend_cell(QStringList& packStr,QString TIMEdata);
extern int excelll(QString TIMEdata);

QmlMqttSubscription::QmlMqttSubscription(QMqttSubscription *s,QmlMqttClient *c)
    : sub(s)          //sub(s)：将传入的 QMqttSubscription 指针 s 赋值给成员变量 sub
    , client(c)       //client(c)：将传入的 MqttClient 指针 c 赋值给成员变量 client
{
    connect(sub, &QMqttSubscription::messageReceived, client,&QmlMqttClient::onDataRec);
    m_topic = sub->topic();   //QMqttSubscription 对象中获取订阅的主题，并将其存储在成员变量 m_topic 中，以便后续使用或查询
}



QmlMqttSubscription::~QmlMqttSubscription()
{
}



QmlMqttClient::QmlMqttClient(QObject *parent)      //状态更新
    : QMqttClient(parent)
{
    connect(&m_client, &QMqttClient::stateChanged, this, &QmlMqttClient::stateChanged);
}




void QmlMqttClient::parse(QByteArray package)    //解包函数
{
    QString message = QString(package);
    message = message.mid(0,message.size() );

    //取消大括号
    if(message.size()>=2 && message.front() == '{' && message.back() == '}'){
        message = message.mid(1,message.size() - 2);
    }
    //分割字符串用逗号为分隔符
    QStringList packageStr = message.split(',');
    qDebug()<<packageStr;

    //toInt() 是一个常见的方法，用于将字符串转换为整数
    if(packageStr[0] == "1")
    {
        setCarSpeed(packageStr[1].toInt());     //车速
        setThroPos(packageStr[2].toInt());      //加速踏板开度
        setBatAlarm(packageStr[3].toInt());     //电池报警状态
        setLmotorSpeed(packageStr[4].toInt());  //左电机速度
        setRmotorSpeed(packageStr[5].toInt());  //右电机速度
        setBatcur(packageStr[6].toFloat());     //电池电流
        setBatLevel(packageStr[7].toInt());     //电池电量水平
        setGearMode(packageStr[8].toInt());     //档位模式
        setCarMode(packageStr[9].toInt());      //车辆模式
        setAcc_x(packageStr[10].toFloat());     //加速度计X轴
        setAcc_y(packageStr[11].toFloat());     //加速度计Y轴
        setAcc_z(packageStr[12].toFloat());     //加速度计Z轴
        setroll(packageStr[13].toFloat());      //滚转角

        attend_cell(packageStr,timedata);       //数据写入表格
    }
    else
    {
        setLmotortorq(packageStr[1].toInt());   //左电机扭矩
        setRmotortorq(packageStr[2].toInt());   //右电机扭矩
        setBatVol(packageStr[3].toInt());       //电池电压
        setCarDistance(packageStr[4].toInt());  //行驶距离
        setMcu1Temp(packageStr[5].toInt());     //电机控制器1温度
        setMcu2Temp(packageStr[6].toInt());     //电机控制器2温度
        setBrakeTravel(packageStr[7].toInt());  //制动踏板开度
        setLmotorTemp(packageStr[8].toInt());   //左电机温度
        setRmotorTemp(packageStr[9].toInt());   //右电机温度
        setLbatAlr(packageStr[10].toInt());     //低压电池报警状态
        setAngle(packageStr[11].toInt());       //方向盘角度
        setyaw(packageStr[12].toFloat());       //偏航角
        setpitch(packageStr[13].toFloat());     //俯仰角

        attend_cell(packageStr,timedata);       //数据写入表格
    }
}


QMqttClient::ClientState QmlMqttClient::state() const  //获得当前mqtt客户端状态
{
    return m_client.state();
}



void QmlMqttClient::setState(const ClientState &newState)  //设置新状态值
{
    m_client.setState(newState);
}




void QmlMqttClient::connectToHost()             //按下按钮连接
{
    m_client.setHostname("123.57.107.238");
    m_client.setPort(1883);
    m_client.setUsername("lingyun");
    m_client.setPassword("lingyun666");
    m_client.connectToHost();
    timedata = QDateTime::currentDateTime().toString("yyyyMMddHHmm");
    excelll(timedata);
}



void QmlMqttClient::disconnectFromHost()        //按下按钮断开
{
    m_client.disconnectFromHost();
}




QmlMqttSubscription* QmlMqttClient::subscribe(const QString &topic)  //按下按钮用于订阅指定主题
{                                                              //表示该函数返回一个指向 MqttSubscription 对象的指针
    auto sub = m_client.subscribe(topic, 0);  //第二个参数 0 是 QoS（Quality of Service）级别，这里设置为最低级别（即最多一次）。这意味着消息传递不保证顺序和可靠性。
    auto result = new QmlMqttSubscription(sub, this);  //获取到的订阅对象sub和当前 MqttClient实例(this)来创建一个新的 MqttSubscription对象；这个对象将负责处理与特定主题相关的所有订阅行为
    return result;  //返回新创建的 QmlMqttSubscription 对象的指针给调用者，允许外部代码与该订阅进行交互，例如取消订阅、检查状态等
}



void QmlMqttClient::publishmessage(const QString &topic)   //按下按钮发送消息
{
    if (m_client.publish(topic,"projectttttttttt") == -1)  //如果 publish 方法返回 -1，表示发布失败
    qDebug()<<"no message";
}



void QmlMqttClient::onDataRec(const QMqttMessage &qmsg)  //接收消息处理
{
    qDebug()<<"message is"<<qmsg.payload();
    parse(qmsg.payload());
}
