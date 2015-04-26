# JSONToPhpCode
根据JSON 生成 生成JSON的PHP代码。 


JSONToPhpCode 是一个根据JSON字符串 反向生成php代码的工具项目. 

用于根据接口文档， 反向生成php代码， 直接运用于接口。

##From 
     {
       "content": {
        " depositLoanAccount ": "6226**********5644",
        " incomeApproach": "返还至存贷通账户",
        " managementExpense": "100.08元",
        " cycle ": "3个月",
        "loanList": [
            {
                "cardId": "00002",
                "cardNum": "6226**********5644",
                "loanAmount": "100万元"
            },
            {
                "cardId": "00002",
                "cardNum": "6226**********5644",
                "loanAmount": "100万元"
            }
        ],
        "depositList": [
            {
                "cardId": "00002",
                "cardNum": "6226**********5644"
            },
            {
                "cardId": "00002",
                "cardNum": "6226**********5644"
            }
        ]
     },
      "returnDescription": "Operate Success",
      "rtnCode": "10000"
     }


##To
    <?php
      error_reporting(0);
      header('Content-Type: application/json');
      $object1-> managementExpense="100.08元";
      $object1-> incomeApproach="返还至存贷通账户";
      $array1430015017926155 = array();
      $object3->cardNum="6226**********5644";
      $object3->cardId="00002";
      array_push($array1430015017926155, $object3);
      $object4->cardNum="6226**********5644";
      $object4->cardId="00002";
      array_push($array1430015017926155, $object4);
      $object1->depositList=$array1430015017926155;
      $object1-> cycle ="3个月";
      $array1430015017926239 = array();
      $object6->cardNum="6226**********5644";
      $object6->cardId="00002";
      $object6->loanAmount="100万元";
      array_push($array1430015017926239, $object6);
      $object7->cardNum="6226**********5644";
      $object7->cardId="00002";
      $object7->loanAmount="100万元";
      array_push($array1430015017926239, $object7);
      $object1->loanList=$array1430015017926239;
      $object1-> depositLoanAccount ="6226**********5644";
      $object0->content=$object1;
      $object0->returnDescription="Operate Success";
      $object0->rtnCode="10000";
      echo json_encode($object0, JSON_PRETTY_PRINT);
     ?>

