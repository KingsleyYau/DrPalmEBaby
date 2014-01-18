//
//  DrClientLanguageDef.h
//  DrPalm
//
//  Created by fgx_lion on 12-3-19.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#ifndef DrPalm_DrClientLanguageDef_h
#define DrPalm_DrClientLanguageDef_h

#import "LanguageDef.h"

#define DrClientToLocalizedString(keyString) NSLocalizedStringFromTable(keyString, @"DrClientModule", nil)

#define DrClientModuleTitle         DrClientToLocalizedString(@"DrClient_ModuleTitle")

#define DrClientUsernameText        DrClientToLocalizedString(@"DrClient_UsernameText")
#define DrClientPasswordText        DrClientToLocalizedString(@"DrClient_PasswordText")
#define DrClientUsername            DrClientToLocalizedString(@"DrClient_username")
#define DrClientPassword            DrClientToLocalizedString(@"DrClient_password")
#define DrClientLogin               DrClientToLocalizedString(@"DrClient_Login")
#define DrClientRememberPassword    DrClientToLocalizedString(@"DrClient_RememberMyPassword")
#define DrClientSignAutomatically   DrClientToLocalizedString(@"DrClient_SignInAutomatically")
#define DrClientReconnectAutomatically  DrClientToLocalizedString(@"DrClient_ReconnectAutomatically")
#define DrClientUsedTime            DrClientToLocalizedString(@"DrClient_UsedTime")
#define DrClientUsedFlux            DrClientToLocalizedString(@"DrClient_UsedFlux")
#define DrClientMin                 DrClientToLocalizedString(@"DrClient_Min")
#define DrClientMByte               DrClientToLocalizedString(@"DrClient_MByte")
#define DrClientLogout              DrClientToLocalizedString(@"DrClient_Logout")

#define DrClientTips                DrClientToLocalizedString(@"DrClient_Tips")
#define DrClientOK                  DrClientToLocalizedString(@"DrClient_OK")
#define DrClientEnterUsername       DrClientToLocalizedString(@"DrClient_EnterYourUsername")
#define DrClientEnterPassword       DrClientToLocalizedString(@"DrClient_EnterYourPassword")
#define DrClientAlreadOnline        DrClientToLocalizedString(@"DrClient_AlreadyOnline")
#define DrClientCanNotFind          DrClientToLocalizedString(@"DrClient_CanNotFind")
#define DrClientIPNotAllow          DrClientToLocalizedString(@"DrClient_IPDoesNotAllow")
#define DrClientNotAllowLogin       DrClientToLocalizedString(@"DrClient_NotAllowLogin")
#define DrClientNotAllowChangePassword  DrClientToLocalizedString(@"DrClient_NotAllowChangePassword")
#define DrClientInvalidAccountPassword  DrClientToLocalizedString(@"DrClient_InvalidAccountPassword")
#define DrClientTieUp               DrClientToLocalizedString(@"DrClient_TieUp")
#define DrClientAddressOnlyIP       DrClientToLocalizedString(@"DrClient_UseAppointedAddressOnlyIP")
#define DrClientChargeOverspend     DrClientToLocalizedString(@"DrClient_ChargeOverspend")
#define DrClientBreakOff            DrClientToLocalizedString(@"DrClient_BreakOff")
#define DrClientSystemBufferFull    DrClientToLocalizedString(@"DrClient_SystemBufferFull")
#define DrClientTieUpCanNotAmend    DrClientToLocalizedString(@"DrClient_TieUpCanNotAmend")
#define DrClientConfirmPasswordDiffer   DrClientToLocalizedString(@"DrClient_ConfirmPasswordDiffer")
#define DrClientPasswordAmendSuccessed  DrClientToLocalizedString(@"DrClient_PasswordAmendSuccessed")
#define DrClientAddressOnlyMAC      DrClientToLocalizedString(@"DrClient_UseAppointedAddressOnlyMAC")
#define DrClientNotAllowUseNAT      DrClientToLocalizedStirng(@"DrClient_NotAllowUseNAT")
#define DrClientNoWiFi              DrClientToLocalizedString(@"DrClient_NoWiFi")
#endif
