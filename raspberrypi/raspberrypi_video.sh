#! /bin/sh
BASE_DIR = "/usr/local/project/raspberrypi_video/raspberrypi/alone/"
CAPTURE_VIDEO = "/usr/local/project/raspberrypi_video/raspberrypi/alone/capture_video_alone.py"
SOCKET_CLIENT = "/usr/local/project/raspberrypi_video/raspberrypi/alone/socket_client_alone.py"

start() {
    cd $BASE_DIR
    [ -x $SOCKET_CLIENT ] || exit 5
    nohup python $SOCKET_CLIENT > /dev/null 2>&1 &
    retval1=$?
    [ -x $CAPTURE_VIDEO ] || exit 5
    nohup python $CAPTURE_VIDEO > /dev/null 2>&1 &
    retval2=$?
    $retval = `expr $retval1 + $retval2`
    return $retval
}
start_socket_client() {
    cd $BASE_DIR
    [ -x $SOCKET_CLIENT ] || exit 5
    nohup python $SOCKET_CLIENT > /dev/null 2>&1 &
    retval=$?
    return $retval
}
start_capture_video() {
    cd $BASE_DIR
    [ -x $CAPTURE_VIDEO ] || exit 5
    nohup python $CAPTURE_VIDEO > /dev/null 2>&1 &
    retval=$?
    return $retval
}
stop() {
    PID1=$(ps -e|grep capture_video_alone.py|grep ^[^grep]|awk '{printf $1}')
    kill -9 ${PID1}
    if [ $? -eq 0 ];then
    echo "kill $input1 success"
    else
        echo "kill $input1 fail"
    fi
    PID2=$(ps -e|grep socket_client_alone.py|grep ^[^grep]|awk '{printf $1}')
    kill -9 ${PID2}
    if [ $? -eq 0 ];then
    echo "kill $input1 success"
    else
        echo "kill $input1 fail"
    fi
}
restart() {
    stop
    sleep 1
    start
}
watch_dog(){
    p_count_socket_client_cmd=$(ps -e|grep socket_client_alone.py|grep ^[^grep]|wc -l)
    p_count_socket_client=${p_count_socket_client_cmd}
    if [[ $p_count_socket_client -eq 0 ]];then
        start_socket_client
    fi
    p_count_capture_video_cmd=$(ps -e|grep capture_video_alone.py|grep ^[^grep]|wc -l)
    p_count_capture_video=${p_count_capture_video_cmd}
    if [[ $p_count_capture_video -eq 0 ]];then
        start_capture_video
    fi
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    watchdog)
        watch_dog || exit 0
        ;;
    *)
        echo $"Usage: $0 {start|stop|watchdog}"
        exit 2
esac
