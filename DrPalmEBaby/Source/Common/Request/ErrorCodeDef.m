//
//  ErrorCodeDef.c
//  DrPalm
//
//  Created by fgx_lion on 12-3-26.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "ErrorCodeDef.h"
#import "LanguageDef.h"

#define ErrCodeToLocalizedString(keyString) NSLocalizedStringFromTable(keyString, @"ErrorCodeString", nil)

#define ErrorCodeDefault            ErrCodeToLocalizedString(@"ErrorCode_Default")   //匹配不到

#define ErrCodeInvalidSchoolKey     ErrCodeToLocalizedString(@"ErrCode_InvalidSchoolKey")   //无效School参数
#define ErrCodeUnopenSchoolGatway   ErrCodeToLocalizedString(@"ErrCode_UnopenSchoolGatway") //学校未开通网关
#define ErrCodeSendBugError         ErrCodeToLocalizedString(@"ErrCode_SendBugError")       //申报故障或建议错误
#define ErrCodeUnkownClientType     ErrCodeToLocalizedString(@"ErrCode_UnkownClientType")   //未知客户端类型
#define ErrCodeNoNewPacket          ErrCodeToLocalizedString(@"ErrCode_NoNewPacket")        //没有新资源包
#define ErrCodePacketNotExist       ErrCodeToLocalizedString(@"ErrCode_PacketNotExist")     //资源包不存在
#define ErrCodeUnkownError          ErrCodeToLocalizedString(@"ErrCode_UnkownError")        //未知错误

#define ErrCodeAccountNotExist      ErrCodeToLocalizedString(@"ErrCode_AccountNotExist")    //帐号不存在
#define ErrCodeLoginInfoNotMatch    ErrCodeToLocalizedString(@"ErrCode_LoginInfoNotMatch")  //帐号或密码错误
#define ErrCodeLoginParamEmpty      ErrCodeToLocalizedString(@"ErrCode_LoginParamEmpty")    //登录帐号、密码、学校ID为空
#define ErrCodeInvalidSessionKey    ErrCodeToLocalizedString(@"ErrCode_InvalidSessionKey")  //无效SessionKey
#define ErrCodeInvalidProfileKey    ErrCodeToLocalizedString(@"ErrCode_InvalidProfileKey")  //无效ProfileKey

#define ErrCodeInvalidSchoolId          ErrCodeToLocalizedString(@"ErrCode_InvalidSchoolId")
#define ErrCodeAccounTypeEmpty          ErrCodeToLocalizedString(@"ErrCode_AccounTypeEmpty")
#define ErrCodeAccountTypeNotCorrect    ErrCodeToLocalizedString(@"ErrCode_AccountTypeNotCorrect")
#define ErrCodeAccountRightForbidden    ErrCodeToLocalizedString(@"ErrCode_AccountRightForbidden")
#define ErrCodeAccountBlockup           ErrCodeToLocalizedString(@"ErrCode_AccountBlockup")
#define ErrCodeAccountEmailEmpty        ErrCodeToLocalizedString(@"ErrCode_AccountEmailEmpty")  

#define ErrCodeNotTeacher           ErrCodeToLocalizedString(@"ErrCode_NotTeacher")         //非教师身份
#define ErrCodeOrgNotExist          ErrCodeToLocalizedString(@"ErrCode_OrgNotExist")        //组织不存在

#define ErrCodeEventStartDateEmpty  ErrCodeToLocalizedString(@"ErrCode_EventStartDateEmpty")//发布event起始时间为空
#define ErrCodeEventEndDateEmpty    ErrCodeToLocalizedString(@"ErrCode_EventEndDateEmpty")  //发布event结束时间为空
#define ErrCodeReceiverIDEmpty      ErrCodeToLocalizedString(@"ErrCode_ReceiverIDEmpty")    //发布event接收者ID列表为空
#define ErrCodeReceiverNameEmpty    ErrCodeToLocalizedString(@"ErrCode_ReceiverNameEmpty")  //发布event接收者名字列表为空
#define ErrCodeEventLocationEmpty   ErrCodeToLocalizedString(@"ErrCode_EventLocationEmpty") //发布event地点为空
#define ErrCodeEventTypeEmpty       ErrCodeToLocalizedString(@"ErrCode_EventTypeEmpty")     //发布event类型为空
#define ErrCodeEventTitleEmpty      ErrCodeToLocalizedString(@"ErrCode_EventTitleEmpty")    //发布event标题为空
#define ErrCodeEventContentEmpty    ErrCodeToLocalizedString(@"ErrCode_EventContentEmpty")  //发布event内容为空
#define ErrCodeEventUnknowError     ErrCodeToLocalizedString(@"ErrCode_EventUnknowError")   //发布event未知异常
#define ErrCodeEventInvalidEventID  ErrCodeToLocalizedString(@"ErrCode_EventInvalidEventID")//无效event ID

#define ErrCodeNewsIdEmpty          ErrCodeToLocalizedString(@"ErrCode_NewsIdEmpty")
#define ErrCodeNewsVerifyEmpty      ErrCodeToLocalizedString(@"ErrCode_NewsVerifyEmpty")
#define ErrCodeNewsNotExist         ErrCodeToLocalizedString(@"ErrCode_NewsNotExist")
#define ErrCodeNewsUnknowError      ErrCodeToLocalizedString(@"ErrCode_NewsUnknowError")

#define ErrCodeAccountAlreadyExist      ErrCodeToLocalizedString(@"ErrCode_AccountAlreadyExist")
#define ErrCodePhoneNumberNotCorrect    ErrCodeToLocalizedString(@"ErrCode_PhoneNumberNotCorrect")
#define ErrCodePhoneNumberOnly          ErrCodeToLocalizedString(@"ErrCode_PhoneNumberOnly")
#define ErrCodeCheckCodeEmpty           ErrCodeToLocalizedString(@"ErrCode_CheckCodeEmpty")
#define ErrCodeCheckCodeInvalid         ErrCodeToLocalizedString(@"ErrCode_CheckCodeInvalid")
#define ErrCodeCheckCodeNotCorrect      ErrCodeToLocalizedString(@"ErrCode_CheckCodeNotCorrect")

#define ErrCodeActivityNotExist         ErrCodeToLocalizedString(@"ErrCode_ActivityNotExist")
#define ErrCodeAccountForbidden         ErrCodeToLocalizedString(@"ErrCode_AccountForbidden")
#define ErrCodeActivityNotStart         ErrCodeToLocalizedString(@"ErrCode_ActivityNotStart")
#define ErrCodeActivityTooShort         ErrCodeToLocalizedString(@"ErrCode_ActivityTooShort")
#define ErrCodeGiftCheckedAll           ErrCodeToLocalizedString(@"ErrCode_GiftCheckedAll")
#define ErrCodeActivityTheOne           ErrCodeToLocalizedString(@"ErrCode_ActivityTheOne")
#define ErrCodeActivityInvalid          ErrCodeToLocalizedString(@"ErrCode_ActivityInvalid")
#define ErrCodeGiftCheckCodeEmpty       ErrCodeToLocalizedString(@"ErrCode_GiftCheckCodeEmpty")
#define ErrCodeGiftCheckedAll2          ErrCodeToLocalizedString(@"ErrCode_GiftCheckedAll2")
#define ErrCodeAccountNumberNull        ErrCodeToLocalizedString(@"ErrCode_AccountNumberNull")
#define ErrCodeAccountNumberNotExist    ErrCodeToLocalizedString(@"ErrCode_AccountNumberNotExist")
#define ErrCodeCheckCodeNotExist        ErrCodeToLocalizedString(@"ErrCode_CheckCodeNotExist")
#define ErrCodeGiftGetAll               ErrCodeToLocalizedString(@"ErrCode_GiftGetAll")
#define ErrCodeCouponCheckedAll         ErrCodeToLocalizedString(@"ErrCode_CouponCheckedAll")
#define ErrCodeActivityIDEmpty          ErrCodeToLocalizedString(@"ErrCode_ActivityIDEmpty")
#define ErrCodeGiftIDEmpty              ErrCodeToLocalizedString(@"ErrCode_GiftIDEmpty")
#define ErrCodeBonusNotEnough           ErrCodeToLocalizedString(@"ErrCode_BonusNotEnough")
#define ErrCodeGiftGetAll2              ErrCodeToLocalizedString(@"ErrCode_GiftGetAll2")
#define ErrCodeGiftCheckedAll3          ErrCodeToLocalizedString(@"ErrCode_GiftCheckedAll3")

NSString* ErrorCodeToString(NSString* errorCode)
{
    NSString* errorString = [NSString stringWithFormat:@"%@",ErrorCodeDefault];
    if(errorCode.length > 0)
        errorString = [NSString stringWithFormat:@"%@:%@",ErrorCodeDefault,errorCode];
    if ([errorCode isEqualToString:InvalidSchoolKey]){
        //无效School参数
        errorString = ErrCodeInvalidSchoolKey;
    }
    else if ([errorCode isEqualToString:UnopenSchoolGatway]){
        //学校未开通网关
        errorString = ErrCodeUnopenSchoolGatway;
    }
    else if ([errorCode isEqualToString:SendBugError]){
        //申报故障或建议错误
        errorString = ErrCodeSendBugError;
    }
    else if ([errorCode isEqualToString:UnkownClientType]){
        //未知客户端类型
        errorString = ErrCodeUnkownClientType;
    }
    else if ([errorCode isEqualToString:NoNewPacket]){
        //没有新资源包
        errorString = ErrCodeNoNewPacket;
    }
    else if ([errorCode isEqualToString:PacketNotExist]){
        //资源包不存在
        errorString = ErrCodePacketNotExist;
    }
    else if ([errorCode isEqualToString:UnkownError]){
        //未知错误
        errorString = ErrCodeUnkownError;
    }
    else if ([errorCode isEqualToString:AccountNotExist]){
        //帐号不存在
        errorString = ErrCodeAccountNotExist;
    }
    else if ([errorCode isEqualToString:LoginInfoNotMatch]){
        //帐号或密码错误
        errorString = ErrCodeLoginInfoNotMatch;
    }
    else if ([errorCode isEqualToString:LoginParamEmpty]){
        //登录帐号、密码、学校ID为空
        errorString = ErrCodeLoginParamEmpty;
    }
    else if ([errorCode isEqualToString:InvalidSessionKey]){
        //无效SessionKey
        errorString = ErrCodeInvalidSessionKey;
    }
    else if ([errorCode isEqualToString:InvalidProfileKey]){
        //无效ProfileKey
        errorString = ErrCodeInvalidProfileKey;
    }
    
    else if ([errorCode isEqualToString:InvalidSchoolId]){
        errorString = ErrCodeInvalidSchoolId;
    }
    else if ([errorCode isEqualToString:AccounTypeEmpty]){
        errorString = ErrCodeAccounTypeEmpty;
    }
    else if ([errorCode isEqualToString:AccountTypeNotCorrect]){
        errorString = ErrCodeAccountTypeNotCorrect;
    }
    else if ([errorCode isEqualToString:AccountRightForbidden]){
        errorString = ErrCodeAccountRightForbidden;
    }
    else if ([errorCode isEqualToString:AccountBlockup]){
        errorString = ErrCodeAccountBlockup;
    }
    else if ([errorCode isEqualToString:AccountEmailEmpty]){
        errorString = ErrCodeAccountEmailEmpty;
    }
    
    else if ([errorCode isEqualToString:NotTeacher]){
        //非教师身份
        errorString = ErrCodeNotTeacher;
    }
    else if ([errorCode isEqualToString:OrgNotExist]){
        //组织不存在
        errorString = ErrCodeOrgNotExist;
    }
    else if ([errorCode isEqualToString:EventStartDateEmpty]){
        //发布event起始时间为空
        errorString = ErrCodeEventStartDateEmpty;
    }
    else if ([errorCode isEqualToString:EventEndDateEmpty]){
        //发布event结束时间为空
        errorString = ErrCodeEventEndDateEmpty;
    }
    else if ([errorCode isEqualToString:ReceiverIDEmpty]){
        //发布event接收者ID列表为空
        errorString = ErrCodeReceiverIDEmpty;
    }
    else if ([errorCode isEqualToString:ReceiverNameEmpty]){
        //发布event接收者名字列表为空
        errorString = ErrCodeReceiverNameEmpty;
    }
    else if ([errorCode isEqualToString:EventLocationEmpty]){
        //发布event地点为空
        errorString = ErrCodeEventLocationEmpty;
    }
    else if ([errorCode isEqualToString:EventTypeEmpty]){
        //发布event类型为空
        errorString = ErrCodeEventTypeEmpty;
    }
    else if ([errorCode isEqualToString:EventTitleEmpty]){
        //发布event标题为空
        errorString = ErrCodeEventTitleEmpty;
    }
    else if ([errorCode isEqualToString:EventContentEmpty]){
        //发布event内容为空
        errorString = ErrCodeEventContentEmpty;
    }
    else if ([errorCode isEqualToString:EventUnknowError]){
        //发布event未知异常
        errorString = ErrCodeEventUnknowError;
    }
    else if ([errorCode isEqualToString:EventInvalidEventID]){
        //无效event ID
        errorString = ErrCodeEventInvalidEventID;
    }
    /* 活动 */
    else if ([errorCode isEqualToString:ActivityNotExist]){
        errorString = ErrCodeEventInvalidEventID;
    }
    else if ([errorCode isEqualToString:AccountForbidden]){
        errorString = ErrCodeAccountForbidden;
    }
    else if ([errorCode isEqualToString:ActivityNotStart]){
        errorString = ErrCodeActivityNotStart;
    }
    else if ([errorCode isEqualToString:ActivityTooShort]){
        errorString = ErrCodeActivityTooShort;
    }
    else if ([errorCode isEqualToString:GiftCheckedAll]){
        errorString = ErrCodeGiftCheckedAll;
    }
    else if ([errorCode isEqualToString:ActivityTheOne]){
        errorString = ErrCodeActivityTheOne;
    }
    else if ([errorCode isEqualToString:ActivityInvalid]){
        errorString = ErrCodeActivityInvalid;
    }
    else if ([errorCode isEqualToString:GiftCheckCodeEmpty]){
        errorString = ErrCodeGiftCheckCodeEmpty;
    }
    else if ([errorCode isEqualToString:GiftCheckedAll2]){
        errorString = ErrCodeGiftCheckedAll2;
    }
    else if ([errorCode isEqualToString:AccountNumberNull]){
        errorString = ErrCodeAccountNumberNull;
    }
    else if ([errorCode isEqualToString:AccountNumberNotExist]){
        errorString = ErrCodeAccountNumberNotExist;
    }
    else if ([errorCode isEqualToString:CheckCodeNotExist]){
        errorString = ErrCodeCheckCodeNotExist;
    }
    else if ([errorCode isEqualToString:GiftGetAll]){
        errorString = ErrCodeGiftGetAll;
    }
    else if ([errorCode isEqualToString:CouponCheckedAll]){
        errorString = ErrCodeCouponCheckedAll;
    }
    else if ([errorCode isEqualToString:ActivityIDEmpty]){
        errorString = ErrCodeActivityIDEmpty;
    }
    else if ([errorCode isEqualToString:GiftIDEmpty]){
        errorString = ErrCodeGiftIDEmpty;
    }
    else if ([errorCode isEqualToString:BonusNotEnough]){
        errorString = ErrCodeBonusNotEnough;
    }
    else if ([errorCode isEqualToString:GiftGetAll2]){
        errorString = ErrCodeGiftGetAll2;
    }
    else if ([errorCode isEqualToString:GiftCheckedAll3]){
        errorString = ErrCodeGiftCheckedAll3;
    }
    /* 注册 */
    else if ([errorCode isEqualToString:AccountAlreadyExist]){
        errorString = ErrCodeAccountAlreadyExist;
    }
    else if ([errorCode isEqualToString:PhoneNumberNotCorrect]){
        errorString = ErrCodePhoneNumberNotCorrect;
    }
    else if ([errorCode isEqualToString:PhoneNumberOnly]){
        errorString = ErrCodePhoneNumberOnly;
    }
    else if ([errorCode isEqualToString:CheckCodeEmpty]){
        errorString = ErrCodeCheckCodeEmpty;
    }
    else if ([errorCode isEqualToString:CheckCodeInvalid]){
        errorString = ErrCodeCheckCodeInvalid;
    }
    else if ([errorCode isEqualToString:CheckCodeNotCorrect]){
        errorString = ErrCodeCheckCodeNotCorrect;
    }
    /* 新闻*/
    else if ([errorCode isEqualToString:NewsIdEmpty]){
        errorString = ErrCodeNewsIdEmpty;
    }
    else if ([errorCode isEqualToString:NewsVerifyEmpty]){
        errorString = ErrCodeNewsVerifyEmpty;
    }
    else if ([errorCode isEqualToString:NewsNotExist]){
        errorString = ErrCodeNewsNotExist;
    }
    else if ([errorCode isEqualToString:NewsUnknowError]){
        errorString = ErrCodeNewsUnknowError;
    }
    return errorString;
}

