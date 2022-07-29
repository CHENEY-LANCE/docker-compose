#!/bin/bash
to=$1
subject=$2
text=$3

#此处的 xxxxx 就是刚刚复制存留的 api 接口地址。
curl -i -X POST \
'https://oapi.dingtalk.com/robot/send?
#填入钉钉的token
access_token=123c1421f5b35a971eccbd5c77aaa25cb8063b20b9858bebb7372f294cc868a9b' \
-H 'Content-type':'application/json' \
-d '
{
  "msgtype": "text",
     "text": {
        "content": "'监控报警：''"$text"'"
        },
  "at":{
    "atMobiles":[
      "'"$1"'"
      ],
  "isAtAll":false
   } 
}'
