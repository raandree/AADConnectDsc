#-------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation.  All rights reserved.
#-------------------------------------------------------------------------

#
# Event IDs
#
Set-Variable EventIdPwdSyncTroubleshootingRun               2001 -Option Constant -Scope script
Set-Variable EventIdSingleObjectDiagnosticsRun              2002 -Option Constant -Scope script
Set-Variable EventIdStagingModeEnabled                      2003 -option Constant -Scope script
Set-Variable EventIdConnectorNoHeartBeat                    2004 -Option Constant -Scope script
Set-variable EventIdDomainIsNotReachable                    2005 -Option Constant -Scope script
Set-Variable EventIdPwdSyncLocalConfigDisabled              2006 -Option Constant -Scope script
Set-Variable EventIdPwdSyncLocalAndCloudConfigDifferent     2007 -Option Constant -Scope script
Set-Variable EventIdConnectorAccountPwdSyncPermissionFailed 2008 -Option Constant -Scope script
Set-Variable EventIdPwdSyncLocalEnabledAndCloudDisabled     2010 -Option Constant -Scope script
Set-Variable EventIdPwdSyncLocalDisabledAndCloudEnabled     2011 -Option Constant -Scope script
Set-Variable EventIdPwdSyncCloudConfigNull                  2012 -Option Constant -Scope script

Set-Variable EventIdPersistentDomainFailure                 2013 -Option Constant -Scope script
Set-Variable EventIdTemporaryDomainFailure                  2014 -Option Constant -Scope script
Set-Variable EventIdCannotResolveDomainController           2015 -Option Constant -Scope script
Set-Variable EventIdCannotLocateDomainController            2016 -Option Constant -Scope script
Set-Variable EventIdCannotBindToDomainController            2017 -Option Constant -Scope script
Set-Variable EventIdPersistentRPCError                      2018 -Option Constant -Scope script
Set-Variable EventIdTemporaryRPCError                       2019 -Option Constant -Scope script
Set-Variable EventIdPersistentLDAPConnectionError           2020 -Option Constant -Scope script
Set-Variable EventIdTemporaryLDAPConnectionError            2021 -Option Constant -Scope script
Set-Variable EventIdPasswordSyncCryptographicException      2022 -Option Constant -Scope script
Set-Variable EventIdPasswordSyncInternalError               2023 -Option Constant -Scope script

# Password Hash Sync Batch AWS API Call Failures - Event IDs
Set-Variable EventIdPwdSyncBatchAWSFailure                                           2024 -Option Constant -Scope script
Set-Variable EventIdPwdSyncBatchAWSFailurePwdSyncCloudConfigNotActivated             2025 -Option Constant -Scope script
Set-Variable EventIdPwdSyncBatchAWSFailureIdentitySyncCloudConfigNotActivated        2026 -Option Constant -Scope script
Set-Variable EventIdPwdSyncBatchAWSFailureAADAccessDenied                            2027 -Option Constant -Scope script
Set-Variable EventIdPwdSyncBatchAWSFailureEndpointNotFoundException                  2028 -Option Constant -Scope script
Set-Variable EventIdPwdSyncBatchAWSFailureSecurityNegotiationException               2029 -Option Constant -Scope script
Set-Variable EventIdPwdSyncBatchAWSFailureAdalServiceException                       2030 -Option Constant -Scope script
Set-Variable EventIdPwdSyncBatchAWSFailureAdalServiceExUserRealmDiscoveryFailed      2031 -Option Constant -Scope script
Set-Variable EventIdPwdSyncBatchAWSFailureAdalServiceExAccountMustBeAddedToTenant    2032 -Option Constant -Scope script
Set-Variable EventIdPwdSyncBatchAWSFailureAdalServiceExOldPasswordUsed               2033 -Option Constant -Scope script   
Set-Variable EventIdPwdSyncBatchAWSFailureAdalServiceExAccountDisabled               2034 -Option Constant -Scope script
Set-Variable EventIdPwdSyncBatchAWSFailureAdalServiceExInvalidUsernameOrPwd          2035 -Option Constant -Scope script  
Set-Variable EventIdPwdSyncBatchAWSFailureAdalServiceExTenantNotFound                2036 -Option Constant -Scope script

# Password Hash Sync Ping AWS API Call Failures - Event IDs
Set-Variable EventIdPwdSyncPingAWSFailure                                            2037 -Option Constant -Scope script
Set-Variable EventIdPwdSyncPingAWSFailurePwdSyncCloudConfigNotActivated              2038 -Option Constant -Scope script
Set-Variable EventIdPwdSyncPingAWSFailureIdentitySyncCloudConfigNotActivated         2039 -Option Constant -Scope script
Set-Variable EventIdPwdSyncPingAWSFailureAADAccessDenied                             2040 -Option Constant -Scope script
Set-Variable EventIdPwdSyncPingAWSFailureEndpointNotFoundException                   2041 -Option Constant -Scope script
Set-Variable EventIdPwdSyncPingAWSFailureSecurityNegotiationException                2042 -Option Constant -Scope script
Set-Variable EventIdPwdSyncPingAWSFailureAdalServiceException                        2043 -Option Constant -Scope script
Set-Variable EventIdPwdSyncPingAWSFailureAdalServiceExUserRealmDiscoveryFailed       2044 -Option Constant -Scope script
Set-Variable EventIdPwdSyncPingAWSFailureAdalServiceExAccountMustBeAddedToTenant     2045 -Option Constant -Scope script
Set-Variable EventIdPwdSyncPingAWSFailureAdalServiceExOldPasswordUsed                2046 -Option Constant -Scope script   
Set-Variable EventIdPwdSyncPingAWSFailureAdalServiceExAccountDisabled                2047 -Option Constant -Scope script
Set-Variable EventIdPwdSyncPingAWSFailureAdalServiceExInvalidUsernameOrPwd           2048 -Option Constant -Scope script  
Set-Variable EventIdPwdSyncPingAWSFailureAdalServiceExTenantNotFound                 2049 -Option Constant -Scope script

Set-Variable EventIdRestartPwdSyncChannelSuccess                                     2050 -Option Constant -Scope script
Set-Variable EventIdRestartPwdSyncChannelFailure                                     2051 -Option Constant -Scope script
Set-Variable EventIdPwdSyncActivityWithoutHeartbeat                                  2052 -Option Constant -Scope script

# Password Hash Sync Health Task Failure - Event IDs
Set-Variable EventIdPersistentHealthTaskFailure                                      2053 -Option Constant -Scope script
Set-Variable EventIdTemporaryHealthTaskFailure                                       2054 -Option Constant -Scope script

Set-Variable EventIdConnectorPwdSyncStopped                                          2055 -Option Constant -Scope script

Set-Variable EventIdIsPwdSyncGeneralDiagnosticsHelpful                               2056 -Option Constant -Scope script

Set-Variable EventIdSingleObjectConnectorDisabled             2201 -Option Constant -Scope script
Set-Variable EventIdSingleObjectDisconnector                  2202 -Option Constant -Scope script
Set-Variable EventIdSingleObjectNotSyncedToAADCS              2203 -Option Constant -Scope script
Set-Variable EventIdSingleObjectNoADPwdSyncRule               2204 -Option Constant -Scope script
Set-Variable EventIdSingleObjectNoAADPwdSyncRule              2205 -Option Constant -Scope script
Set-Variable EventIdSingleObjectNoPwdHistory                  2206 -Option Constant -Scope script
Set-Variable EventIdSingleObjectFilteredByTarget              2207 -Option Constant -Scope script
Set-Variable EventIdSingleObjectNotExported                   2208 -Option Constant -Scope script
Set-Variable EventIdSingleObjectNoTargetConnection            2209 -Option Constant -Scope script
Set-Variable EventIdSingleObjectSuccess                       2210 -Option Constant -Scope script
Set-Variable EventIdSingleObjectOtherFailure                  2211 -Option Constant -Scope script
Set-Variable EventIdIsPwdSyncSingleObjectDiagnosticsHelpful   2212 -Option Constant -Scope script

#
# Event Messages
#
Set-Variable EventMsgPwdSyncTroubleshootingRun                "Workflow has been run."                                                                                               -Option Constant -Scope script
Set-Variable EventMsgSingleObjectDiagnosticsRun               "Single object diagnostics has been run."                                                                              -Option Constant -Scope script
Set-Variable EventMsgStagingModeEnabled                       "Staging Mode is enabled."                                                                                             -Option Constant -Scope script
Set-Variable EventMsgConnectorNoHeartBeat                     "No Password Hash Synchronization heartbeat is detected for AD Connector - {0}."                                       -Option Constant -Scope script
Set-Variable EventMsgDomainIsNotReachable                     "Domain {0} is not reachable."                                                                                         -Option Constant -Scope script
Set-Variable EventMsgPwdSyncLocalConfigDisabled               "All AD Connectors are disabled."                                                                                      -Option Constant -Scope script
Set-Variable EventMsgPwdSyncLocalAndCloudConfigDifferent      "Local and cloud configurations are different. Local Enabled - {0}, Cloud Enabled - {1}."                              -Option Constant -Scope script
Set-Variable EventMsgConnectorAccountPwdSyncPermissionFailed  "AD Connector account does not have required permission for password hash synchronization. Domain - {0}."              -Option Constant -Scope script
Set-Variable EventMsgRestartPwdSyncChannelSuccess             "Password Hash Synchronization is successfully restarted for AD Connector - {0}."                                      -Option Constant -Scope script
Set-Variable EventMsgRestartPwdSyncChannelFailure             "Password Hash Synchronization could NOT be restarted for AD Connector - {0}."                                         -Option Constant -Scope script
Set-Variable EventMsgConnectorPwdSyncStopped                  "Password Hash Synchronization is NOT running for AD Connector - {0}."                                                 -Option Constant -Scope script
Set-Variable EventMsgPwdSyncActivityWithoutHeartbeat          "There is password hash synchronization activity but NO heartbeat for AD Connector - {0}."                             -Option Constant -Scope script

Set-Variable EventMsgPersistentDomainFailure                  "Password hash synchronization agent is continuously getting domain failures. Domain - {0}"                            -Option Constant -Scope script
Set-Variable EventMsgTemporaryDomainFailure                   "Password hash synchronization agent had domain failure. Domain - {0}"                                                 -Option Constant -Scope script
Set-Variable EventMsgCannotResolveDomainController            "Password hash synchronization agent could not resolve a domain controller. Domain - {0}"                              -Option Constant -Scope script
Set-Variable EventMsgCannotLocateDomainController             "Password hash synchronization agent could not locate a domain controller. Domain - {0}"                               -Option Constant -Scope script
Set-Variable EventMsgCannotBindToDomainController             "Password hash synchronization agent could not bind to a domain controller. Domain - {0}"                              -Option Constant -Scope script
Set-Variable EventMsgPersistentRPCError                       "Password hash synchronization agent is continuously getting RPC errors. Domain - {0}"                                 -Option Constant -Scope script
Set-Variable EventMsgTemporaryRPCError                        "Password hash synchronization agent had RPC error. Domain - {0}"                                                      -Option Constant -Scope script
Set-Variable EventMsgPersistentLDAPConnectionError            "Password hash synchronization agent is continuously getting LDAP connection errors. Domain - {0}"                     -Option Constant -Scope script
Set-Variable EventMsgTemporaryLDAPConnectionError             "Password hash synchronization agent had LDAP connection error. Domain - {0}"                                          -Option Constant -Scope script
Set-Variable EventMsgPasswordSyncCryptographicException       "Password hash synchronization agent had System.Security.Cryptography.CryptographicException. Domain - {0}"            -Option Constant -Scope script
Set-Variable EventMsgPasswordSyncInternalError                "Password hash synchronization agent had internal error. Domain - {0}"                                                 -Option Constant -Scope script

Set-Variable EventMsgPwdSyncBatchAWSFailure                                           "Password Hash Sync Batch AWS API Call Failure."                                                                            -Option Constant -Scope script
Set-Variable EventMsgPwdSyncBatchAWSFailurePwdSyncCloudConfigNotActivated             "Password Hash Sync Batch AWS API Call Failure - Password hash sync cloud configuration is NOT activated."                  -Option Constant -Scope script
Set-Variable EventMsgPwdSyncBatchAWSFailureIdentitySyncCloudConfigNotActivated        "Password Hash Sync Batch AWS API Call Failure - Identity sync cloud configuration is NOT activated."                       -Option Constant -Scope script
Set-Variable EventMsgPwdSyncBatchAWSFailureAADAccessDenied                            "Password Hash Sync Batch AWS API Call Failure - Access to Azure Active Directory has been denied."                         -Option Constant -Scope script
Set-Variable EventMsgPwdSyncBatchAWSFailureEndpointNotFoundException                  "Password Hash Sync Batch AWS API Call Failure - System.ServiceModel.EndpointNotFoundException."                            -Option Constant -Scope script
Set-Variable EventMsgPwdSyncBatchAWSFailureSecurityNegotiationException               "Password Hash Sync Batch AWS API Call Failure - System.ServiceModel.Security.SecurityNegotiationException."                -Option Constant -Scope script
Set-Variable EventMsgPwdSyncBatchAWSFailureAdalServiceException                       "Password Hash Sync Batch AWS API Call Failure - Microsoft.IdentityModel.Clients.ActiveDirectory.AdalServiceException."     -Option Constant -Scope script
Set-Variable EventMsgPwdSyncBatchAWSFailureAdalServiceExUserRealmDiscoveryFailed      "Password Hash Sync Batch AWS API Call Failure - User realm discovery failed (AdalServiceException)."                       -Option Constant -Scope script
Set-Variable EventMsgPwdSyncBatchAWSFailureAdalServiceExAccountMustBeAddedToTenant    "Password Hash Sync Batch AWS API Call Failure - Account must be added to the AAD tenant (AdalServiceException)."           -Option Constant -Scope script
Set-Variable EventMsgPwdSyncBatchAWSFailureAdalServiceExOldPasswordUsed               "Password Hash Sync Batch AWS API Call Failure - Old password is used for authentication (AdalServiceException)."           -Option Constant -Scope script   
Set-Variable EventMsgPwdSyncBatchAWSFailureAdalServiceExAccountDisabled               "Password Hash Sync Batch AWS API Call Failure - User account is disabled (AdalServiceException)."                          -Option Constant -Scope script
Set-Variable EventMsgPwdSyncBatchAWSFailureAdalServiceExInvalidUsernameOrPwd          "Password Hash Sync Batch AWS API Call Failure - Invalid username or password (AdalServiceException)."                      -Option Constant -Scope script  
Set-Variable EventMsgPwdSyncBatchAWSFailureAdalServiceExTenantNotFound                "Password Hash Sync Batch AWS API Call Failure - Tenant not found (AdalServiceException)."                                  -Option Constant -Scope script

Set-Variable EventMsgPwdSyncPingAWSFailure                                            "Password Hash Sync Ping AWS API Call Failure."                                                                             -Option Constant -Scope script
Set-Variable EventMsgPwdSyncPingAWSFailurePwdSyncCloudConfigNotActivated              "Password Hash Sync Ping AWS API Call Failure - Password hash sync cloud configuration is NOT activated."                   -Option Constant -Scope script
Set-Variable EventMsgPwdSyncPingAWSFailureIdentitySyncCloudConfigNotActivated         "Password Hash Sync Ping AWS API Call Failure - Identity sync cloud configuration is NOT activated."                        -Option Constant -Scope script
Set-Variable EventMsgPwdSyncPingAWSFailureAADAccessDenied                             "Password Hash Sync Ping AWS API Call Failure - Access to Azure Active Directory has been denied."                          -Option Constant -Scope script
Set-Variable EventMsgPwdSyncPingAWSFailureEndpointNotFoundException                   "Password Hash Sync Ping AWS API Call Failure - System.ServiceModel.EndpointNotFoundException."                             -Option Constant -Scope script
Set-Variable EventMsgPwdSyncPingAWSFailureSecurityNegotiationException                "Password Hash Sync Ping AWS API Call Failure - System.ServiceModel.Security.SecurityNegotiationException."                 -Option Constant -Scope script
Set-Variable EventMsgPwdSyncPingAWSFailureAdalServiceException                        "Password Hash Sync Ping AWS API Call Failure - Microsoft.IdentityModel.Clients.ActiveDirectory.AdalServiceException."      -Option Constant -Scope script
Set-Variable EventMsgPwdSyncPingAWSFailureAdalServiceExUserRealmDiscoveryFailed       "Password Hash Sync Ping AWS API Call Failure - User realm discovery failed (AdalServiceException)."                        -Option Constant -Scope script
Set-Variable EventMsgPwdSyncPingAWSFailureAdalServiceExAccountMustBeAddedToTenant     "Password Hash Sync Ping AWS API Call Failure - Account must be added to the AAD tenant (AdalServiceException)."            -Option Constant -Scope script
Set-Variable EventMsgPwdSyncPingAWSFailureAdalServiceExOldPasswordUsed                "Password Hash Sync Ping AWS API Call Failure - Old password is used for authentication (AdalServiceException)."            -Option Constant -Scope script   
Set-Variable EventMsgPwdSyncPingAWSFailureAdalServiceExAccountDisabled                "Password Hash Sync Ping AWS API Call Failure - User account is disabled (AdalServiceException)."                           -Option Constant -Scope script
Set-Variable EventMsgPwdSyncPingAWSFailureAdalServiceExInvalidUsernameOrPwd           "Password Hash Sync Ping AWS API Call Failure - Invalid username or password (AdalServiceException)."                       -Option Constant -Scope script  
Set-Variable EventMsgPwdSyncPingAWSFailureAdalServiceExTenantNotFound                 "Password Hash Sync Ping AWS API Call Failure - Tenant not found (AdalServiceException)."                                   -Option Constant -Scope script

Set-Variable EventMsgPersistentHealthTaskFailure                                      "Password hash synchronization agent is continuously getting health task failures. AD Connector - {0}."                     -Option Constant -Scope script
Set-Variable EventMsgTemporaryHealthTaskFailure                                       "Password hash synchronization agent had health task failure. AD Connector - {0}."                                          -Option Constant -Scope script

Set-Variable EventMsgIsPwdSyncGeneralDiagnosticsHelpful                               "Is password hash sync general diagnostics helpful: {0}"                                                                    -Option Constant -Scope script


Set-Variable EventMsgSingleObjectConnectorDisabled            "Password Hash Synchronization is disabled for AD Connector - {0}"                                                                                                    -Option Constant -Scope script
Set-Variable EventMsgSingleObjectDisconnector                 "The object is a disconnector, it does not have a link to the metaverse. AD Connector - {0}, DN - {1}"                                                                -Option Constant -Scope script
Set-Variable EventMsgSingleObjectNotSyncedToAADCS             "The object is not synced to the AAD connector space. AD Connector - {0}, DN - {1}"                                                                                   -Option Constant -Scope script
Set-Variable EventMsgSingleObjectNoADPwdSyncRule              "There is no password hash synchronization rule for AD connector space object. AD Connector - {0}, DN - {1}"                                                          -Option Constant -Scope script
Set-Variable EventMsgSingleObjectNoAADPwdSyncRule             "There is no password hash synchronization rule for target AAD connector space object. AD Connector - {0}, DN - {1}"                                                  -Option Constant -Scope script
Set-Variable EventMsgSingleObjectNoPwdHistory                 "Password Hash Synchronization agent does not have any password change history for the specified object. AD Connector - {0}, DN - {1}"                                -Option Constant -Scope script
Set-Variable EventMsgSingleObjectFilteredByTarget             "FilteredByTarget - Temporary password is filtered by target. AD Connector - {0}, DN - {1}, DateTime - {2}"                                                           -Option Constant -Scope script
Set-Variable EventMsgSingleObjectNotExported                  "TargetNotExportedToDirectory - The object in the AAD connector space has not yet been exported. AD Connector - {0}, DN - {1}, DateTime - {2}"                        -Option Constant -Scope script
Set-Variable EventMsgSingleObjectNoTargetConnection           "NoTargetConnection - The object is not synced to AAD connector space or password hash sync rule(s) are not available. AD Connector - {0}, DN - {1}, DateTime - {2}"  -Option Constant -Scope script
Set-Variable EventMsgSingleObjectSuccess                      "Password hash is synchronized successfully. AD Connector - {0}, DN - {1}, DateTime - {2}"                                                                            -Option Constant -Scope script
Set-Variable EventMsgSingleObjectOtherFailure                 "Password hash synchronization is failed. AD Connector - {0}, DN - {1}, DateTime - {2}, Status - {3}"                                                                 -Option Constant -Scope script
Set-Variable EventMsgIsPwdSyncSingleObjectDiagnosticsHelpful  "Is password hash sync single object diagnostics helpful: {0}"                                                                                                        -Option Constant -Scope script

Function GetPasswordHashSyncCloudConfiguration
{
    param
    (
        [Microsoft.IdentityManagement.PowerShell.ObjectModel.Connector]
        [parameter(mandatory=$true)]
        $AADConnector
    )

    Try
    {
        $aadCompanyFeatures = Get-ADSyncAADCompanyFeature
        $passwordHashSyncCloudConfiguration = $aadCompanyFeatures.PasswordHashSync
        Write-Output $passwordHashSyncCloudConfiguration
    }
    Catch
    {
        Write-Output $null
    }
}

Function GetADConnectorPasswordSyncConfiguration
{
    param
    (
        [Microsoft.IdentityManagement.PowerShell.ObjectModel.Connector]
        [parameter(mandatory=$true)]
        $ADConnector
    )

    Try
    {
        $adConnectorPasswordSyncConfig = Get-ADSyncAADPasswordSyncConfiguration -SourceConnector $ADConnector.Name
        Write-Output $adConnectorPasswordSyncConfig
    }
    Catch
    {
        Write-Output $null
    }
}

Function GetADConnectorLatestPingEvent
{
    param
    (
        [Microsoft.IdentityManagement.PowerShell.ObjectModel.Connector]
        [parameter(mandatory=$true)]
        $ADConnector
    )
    
    $pingEvents = Get-EventLog -LogName "Application" -Source "Directory Synchronization" -InstanceId 654 -After (Get-Date).AddHours(-3) -ErrorAction SilentlyContinue | 
                  Where-Object { $_.Message.ToUpperInvariant().Contains($ADConnector.Identifier.ToString("D").ToUpperInvariant()) } | 
                  Sort-Object  { $_.TimeWritten } -Descending

    if ($pingEvents -eq $null)
    {
        Write-Output $null
    }
    else
    {
        Write-Output $pingEvents[0]
    }
}

Function GetADConnectorPasswordHashSyncLatestActivityEvent
{
    param
    (
        [Microsoft.IdentityManagement.PowerShell.ObjectModel.Connector]
        [parameter(mandatory=$true)]
        $ADConnector
    )

    #
    # The events in the following indicates that there is an ongoing password hash sync activity for the given AD Connector.
    #
    $passwordHashSyncActivityEvents = Get-EventLog -LogName "Application" -Source "Directory Synchronization" -After (Get-Date).AddHours(-2) -ErrorAction SilentlyContinue |
                                      Where-Object { $_.InstanceId -eq 601 -or
                                                     $_.InstanceId -eq 609 -or
                                                     $_.InstanceId -eq 610 -or
                                                     $_.InstanceId -eq 611 -or
                                                     $_.InstanceId -eq 615 -or
                                                     $_.InstanceId -eq 617 -or
                                                     $_.InstanceId -eq 618 -or
                                                     $_.InstanceId -eq 619 -or
                                                     $_.InstanceId -eq 620 -or
                                                     $_.InstanceId -eq 621 -or
                                                     $_.InstanceId -eq 650 -or 
                                                     $_.InstanceId -eq 651 -or
                                                     $_.InstanceId -eq 652 -or
                                                     $_.InstanceId -eq 653 -or
                                                     $_.InstanceId -eq 654 -or
                                                     $_.InstanceId -eq 655 -or
                                                     $_.InstanceId -eq 656 -or 
                                                     $_.InstanceId -eq 657 -or
                                                     $_.InstanceId -eq 660 -or
                                                     $_.InstanceId -eq 661 -or
                                                     $_.InstanceId -eq 662 -or
                                                     $_.InstanceId -eq 663 } |
                                      Where-Object { $_.Message.ToUpperInvariant().Contains($ADConnector.Identifier.ToString("D").ToUpperInvariant()) } |
                                      Sort-Object  { $_.TimeWritten } -Descending

    if ($passwordHashSyncActivityEvents -eq $null)
    {
        Write-Output $null
    }
    else
    {
        Write-Output $passwordHashSyncActivityEvents[0]
    }
}

Function RestartADConnectorPasswordHashSyncChannel
{
    param
    (
        [Microsoft.IdentityManagement.PowerShell.ObjectModel.Connector]
        [parameter(mandatory=$true)]
        $ADConnector,

        [Microsoft.IdentityManagement.PowerShell.ObjectModel.Connector]
        [parameter(mandatory=$true)]
        $AADConnector
    )

    try
    {
        Set-ADSyncAADPasswordSyncConfiguration -SourceConnector $ADConnector.Name -TargetConnector $AADConnector.Name -Enable $false
        Set-ADSyncAADPasswordSyncConfiguration -SourceConnector $ADConnector.Name -TargetConnector $AADConnector.Name -Enable $true

        Start-Sleep -s 10

        WriteEventLog($EventIdRestartPwdSyncChannelSuccess)($EventMsgRestartPwdSyncChannelSuccess -f $ADConnector.Name)

        "Password Hash Synchronization is successfully restarted for AD Connector: $($ADConnector.Name)" | ReportOutput 
    }
    catch
    {
        WriteEventLog($EventIdRestartPwdSyncChannelFailure)($EventMsgRestartPwdSyncChannelFailure -f $ADConnector.Name)

        "Password Hash Synchronization could NOT be restarted for AD Connector: $($ADConnector.Name)" | ReportError
    }
}

Function GetCsObjectPasswordSyncRule
{
    param
    (
        [Microsoft.IdentityManagement.PowerShell.ObjectModel.CsObject]
        [parameter(mandatory=$true)]
        $CsObject
    )

    $syncRules = Get-ADSyncRule

    foreach ($csObjectLink in $CsObject.Lineage)
    {
        Try
        {
            $syncRule = $syncRules | Where { $_.InternalId -eq $csObjectLink.SyncRuleInternalId }

            if ($syncRule.EnablePasswordSync -eq $true)
            {
                Write-Output $syncRule
                return
            }
        }
        Catch
        {
            Write-Warning "A sync rule with internalId `"$($csObjectLink.SyncRuleInternalId)`" referenced on the link was not found"
        }
    }

    Write-Output $null
}

Function GetCsObjectLog
{
    param
    (
        [Microsoft.IdentityManagement.PowerShell.ObjectModel.CsObject]
        [parameter(mandatory=$true)]
        $CsObject,

        [int]
        [parameter(mandatory=$true)]
        $LogEntryCount
    )

    Try
    {
        $csObjectLogEntries = Get-ADSyncCSObjectLog -Identifier $CsObject.ObjectId -Count $LogEntryCount
        Write-Output $csObjectLogEntries
    }
    Catch
    {
        Write-Output $null
    }
}

#
# Test connectivity to a domain or domain controller
#
# Input parameter for domain : fully qualified name of the domain
#
# OR
#
# Input parameter for domain controller : host name of the domain controller
#
Function IsDomainReachable
{
    param
    (
        [string]
        [parameter(mandatory=$true)]
        $Domain
    )

    [System.Reflection.Assembly]::LoadWithPartialName("System.DirectoryServices.Protocols")
    
    $port = 389
    $timeout = New-TimeSpan -Seconds 30

    $directoryIdentifier = New-Object System.DirectoryServices.Protocols.LdapDirectoryIdentifier($Domain, $port)
    $ldapConnection = New-Object System.DirectoryServices.Protocols.LdapConnection($directoryIdentifier)
    $ldapConnection.AuthType = [System.DirectoryServices.Protocols.AuthType]::Anonymous
    $ldapConnection.AutoBind = $false
    $ldapConnection.Timeout = $timeout

    Try
    {
        $ldapConnection.Bind()
        Write-Output $true
    }
    Catch
    {
        Write-Output $false
    }

    $ldapConnection.Dispose()
}

#
# Check if password hash sync agent continuously fails to compute MD5 decryption key.
#
# Checks 667 error events
#
# Measure - 5+ failures in the last 2 hour
#
Function IsPersistentMD5Failure
{

    $passwordSyncMD5ErrorEvents = Get-EventLog -LogName "Application" -Source "Directory Synchronization" -InstanceId 667 -After (Get-Date).AddHours(-2) -ErrorAction SilentlyContinue | 
                                  Sort-Object  { $_.TimeWritten } -Descending

    $numberOfMD5FailuresInLastTwoHours = $passwordSyncMD5ErrorEvents.Length

    if ($numberOfMD5FailuresInLastTwoHours -gt 4)
    {
        $latestPasswordSyncMD5ErrorEventTime = GetDateTimeLocaleEnUs($passwordSyncMD5ErrorEvents[0].TimeGenerated)

        $errorStr = 
        "Password Hash Synchronization agent continuously fails to create a key for decryption. `n" +
        "If Federal Information Processing Standards (FIPS) policy is enabled, updating the configuration for the synchronization service (ADSync) may resolve the issue. `n" +
        "Please see: https://go.microsoft.com/fwlink/?linkid=875725 `n" +
        "Please check 667 error events in the application event logs for details `n" +
        "The latest 667 error event is generated at: $latestPasswordSyncMD5ErrorEventTime UTC "
        
        $errorStr | ReportError

        Write-Host "`r`n"

        Write-Output $true
    }
    else
    {
        Write-Output $false
    }
}

#
# Check if password hash sync agent continuously gets failures for the given domain
#
# Checks 611 error events
#
# Measure - 5+ domain failures in the last 2 hours for the same domain
#
Function IsPersistentDomainFailure
{
    param
    (
        [string]
        [parameter(mandatory=$true)]
        $Domain
    )

    #
    # Differentiate the given domain from the others having the same suffix.
    #
    $DomainName = " " + $Domain.ToUpperInvariant()


    $domainPasswordSyncErrorEvents = Get-EventLog -LogName "Application" -Source "Directory Synchronization" -InstanceId 611 -After (Get-Date).AddHours(-2) -ErrorAction SilentlyContinue | 
                                     Where-Object {($_.Message.ToUpperInvariant().Contains($DomainName))} |
                                     Sort-Object  { $_.TimeWritten } -Descending

    $numberOfDomainFailuresInLastTwoHours = $domainPasswordSyncErrorEvents.Length

    if ($numberOfDomainFailuresInLastTwoHours -gt 4)
    {
        WriteEventLog($EventIdPersistentDomainFailure)($EventMsgPersistentDomainFailure -f $Domain)

        $latestDomainPasswordSyncErrorEventTime = GetDateTimeLocaleEnUs($domainPasswordSyncErrorEvents[0].TimeGenerated)

        $errorStr =
        "`tPassword Hash Synchronization agent is continuously getting failures for domain `"$($Domain)`" `n" +
        "`tPlease check 611 error events in the application event logs for details `n" +
        "`tThe latest 611 error event for the domain `"$($Domain)`" is generated at: $latestDomainPasswordSyncErrorEventTime UTC `n"

        $errorStr | ReportError
        Write-Host "`r`n"

        Write-Output $true
    }
    elseif ($numberOfDomainFailuresInLastTwoHours -gt 0)
    {
        WriteEventLog($EventIdTemporaryDomainFailure)($EventMsgTemporaryDomainFailure -f $Domain)

        Write-Output $false
    }
    else
    {
        Write-Output $false
    }
}

#
# Check if password hash sync agent continuously gets failures for Health Task
#
# Checks 662 error events
#
# Measure - 5+ health task failures in the last 2 hours for the same AD Connector
#
Function IsPersistentHealthTaskFailure
{
    param
    (
        [Microsoft.IdentityManagement.PowerShell.ObjectModel.Connector]
        [parameter(mandatory=$true)]
        $ADConnector
    )

    $adConnectorPwdSyncHealthTaskErrorEvents = Get-EventLog -LogName "Application" -Source "Directory Synchronization" -InstanceId 662 -After (Get-Date).AddHours(-2) -ErrorAction SilentlyContinue |
                                               Where-Object { $_.Message.ToUpperInvariant().Contains($ADConnector.Identifier.ToString("D").ToUpperInvariant()) } |
                                               Sort-Object  { $_.TimeWritten } -Descending

    $numberOfHealthTaskFailuresInLastTwoHours = $adConnectorPwdSyncHealthTaskErrorEvents.Length

    if ($numberOfHealthTaskFailuresInLastTwoHours -gt 4)
    {
        WriteEventLog($EventIdPersistentHealthTaskFailure)($EventMsgPersistentHealthTaskFailure -f $ADConnector.Name)

        $latestADConnectorPwdSyncHealthTaskErrorEventTime = GetDateTimeLocaleEnUs($adConnectorPwdSyncHealthTaskErrorEvents[0].TimeGenerated)

        $errorStr = "`r`n" +
        "`tPassword Hash Synchronization agent is continuously getting failures for AD Connector `"$($ADConnector.Name)`" `n" +
        "`tPlease check 662 and 6900 error events in the application event logs for details `n" +
        "`tPlease make sure AAD connector account is added to AAD Tenant, and username and password for this account are valid `n" +
        "`tThe latest 662 error event for the AD Connector `"$($ADConnector.Name)`" is generated at: $latestADConnectorPwdSyncHealthTaskErrorEventTime UTC `n" +
        "`r`n"

        $errorStr | ReportError

        $errorStr = "`r`n" +
        "`tPassword Hash Synchronization agent is continuously getting failures for AD Connector `"$($ADConnector.Name)`" `n" +
        "`tPlease check 662 and 6900 error events in the application event logs for details `n" +
        "`tPlease make sure AAD connector account is added to AAD Tenant, and username and password for this account are valid `n" +
        "`tThe latest 662 error event for the AD Connector `"$($ADConnector.Name)`" is generated at: $latestADConnectorPwdSyncHealthTaskErrorEventTime UTC `n" +
        "`r`n"

        $errorStr | ReportError
        Write-Output $true
    }
    elseif ($numberOfHealthTaskFailuresInLastTwoHours -gt 0)
    {
        WriteEventLog($EventIdTemporaryHealthTaskFailure)($EventMsgTemporaryHealthTaskFailure -f $ADConnector.Name)

        Write-Output $false
    }
    else
    {
        Write-Output $false
    }
 }

#
# Check if password hash sync agent fails for the given domain due to missing password hash sync AD permissions for AD Connector account
#
Function GetADConnectorAccountLatestPasswordSyncPermissionFailedEvent
{
    param
    (
        [string]
        [parameter(mandatory=$true)]
        $Domain
    )    
    
    $Domain = " " + $Domain.ToUpperInvariant()
    $passwordSyncPermissionRPCErrorCode = "8453".ToUpperInvariant()
    $permissionErrorCallStackEntry = "DrsRpcConnection.OnGetChanges".ToUpperInvariant()
    
    $domainPasswordSyncErrorEvents = Get-EventLog -LogName "Application" -Source "Directory Synchronization" -InstanceId 611 -After (Get-Date).AddHours(-2) -ErrorAction SilentlyContinue | 
                                     Where-Object { $_.Message.ToUpperInvariant().Contains($Domain) -and 
                                                    $_.Message.ToUpperInvariant().Contains($passwordSyncPermissionRPCErrorCode) -and
                                                    $_.Message.ToUpperInvariant().Contains($permissionErrorCallStackEntry) } |
                                     Sort-Object  { $_.TimeWritten } -Descending

    if ($domainPasswordSyncErrorEvents -eq $null)
    {
        Write-Output $null
    }
    else
    {
        Write-Output $domainPasswordSyncErrorEvents[0]
    }
}

#
# Check if password hash sync agent fails to resolve a domain controller for the given domain
#
#
# Reason 1 - Unable to retrieve source domain information
#
# Reason 2 - Unable to resolve source host name
#
Function GetLatestFailureToResolveDomainControllerEvent
{
    param
    (
        [string]
        [parameter(mandatory=$true)]
        $Domain
    )

    #
    # Differentiate the given domain from the others having the same suffix.
    #
    $Domain = " " + $Domain.ToUpperInvariant()

    #
    # event 611 - unable to retrieve source domain information
    #
    $unableToRetrieveSourceDomainInfoCallStackEntry1_611 = "DrsConnection.CreateSourceDomainInformation".ToUpperInvariant()
    $unableToRetrieveSourceDomainInfoCallStackEntry2_611 = "DrsConnection.ReadServerGuids".ToUpperInvariant()

    #
    # event 611 - unable to resolve source host name
    #
    $unableToResolveSourceHostNameCallStackEntry1_611 = "DrsConnection.CreateSourceDomainInformation".ToUpperInvariant()
    $unableToResolveSourceHostNameCallStackEntry2_611 = "DrsConnection.ResolveSourceHostName".ToUpperInvariant()
    $unableToResolveSourceHostNameCallStackEntry3_611 = "Dns.GetHostEntry".ToUpperInvariant()

    $domainPasswordSyncErrorEvents = Get-EventLog -LogName "Application" -Source "Directory Synchronization" -InstanceId 611 -After (Get-Date).AddHours(-2) -ErrorAction SilentlyContinue | 
                                     Where-Object {($_.Message.ToUpperInvariant().Contains($Domain)) -and
                                                   (
                                                        (($_.Message.ToUpperInvariant().Contains($unableToRetrieveSourceDomainInfoCallStackEntry1_611))  -and
                                                         ($_.Message.ToUpperInvariant().Contains($unableToRetrieveSourceDomainInfoCallStackEntry2_611))) -or
                                                        
                                                        (($_.Message.ToUpperInvariant().Contains($unableToResolveSourceHostNameCallStackEntry1_611)) -and
                                                         ($_.Message.ToUpperInvariant().Contains($unableToResolveSourceHostNameCallStackEntry2_611)) -and
                                                         ($_.Message.ToUpperInvariant().Contains($unableToResolveSourceHostNameCallStackEntry3_611)))
                                                    )} |
                                     Sort-Object  { $_.TimeWritten } -Descending

    if ($domainPasswordSyncErrorEvents -eq $null)
    {
        Write-Output $null
    }
    else
    {
        Write-Output $domainPasswordSyncErrorEvents[0]
    }
}

#
# Check if password hash sync agent fails to locate a domain controller for the given domain after successfully
# retrieving source domain information and resolving source host name
#
Function GetLatestFailureToLocateDomainControllerEvent
{
    param
    (
        [string]
        [parameter(mandatory=$true)]
        $Domain
    )

    #
    # Differentiate the given domain from the others having the same suffix.
    #
    $Domain = " " + $Domain.ToUpperInvariant()

    #
    # event 611 - Unable to locate a domain controller
    #
    $unableToLocateDomainControllerCallStackEntry1_611 = "DrsConnection.ResolveDomainController".ToUpperInvariant()
    $unableToLocateDomainControllerCallStackEntry2_611 = "DirectoryUtility.FindPreferredDC".ToUpperInvariant()
    $unableToLocateDomainControllerCallStackEntry3_611 = "Domain.GetDomain".ToUpperInvariant()
    
    $incorrectUsernameOrPasswordCallStackEntryBind = "DirectoryEntry.Bind".ToUpperInvariant()

    $domainPasswordSyncErrorEvents = Get-EventLog -LogName "Application" -Source "Directory Synchronization" -InstanceId 611 -After (Get-Date).AddHours(-2) -ErrorAction SilentlyContinue | 
                                     Where-Object {($_.Message.ToUpperInvariant().Contains($Domain)) -and
                                                   (
                                                        (($_.Message.ToUpperInvariant().Contains($unableToLocateDomainControllerCallStackEntry1_611))   -and
                                                         !($_.Message.ToUpperInvariant().Contains($incorrectUsernameOrPasswordCallStackEntryBind))      -and
                                                         (($_.Message.ToUpperInvariant().Contains($unableToLocateDomainControllerCallStackEntry2_611)) -or
                                                          ($_.Message.ToUpperInvariant().Contains($unableToLocateDomainControllerCallStackEntry3_611))))
                                                    )} |
                                     Sort-Object  { $_.TimeWritten } -Descending

    if ($domainPasswordSyncErrorEvents -eq $null)
    {
        Write-Output $null
    }
    else
    {
        Write-Output $domainPasswordSyncErrorEvents[0]
    }
}

#
# Check if password hash sync agent fails for the given domain due to incorrect username or password of AD Connector account
#
Function GetADConnectorAccountLatestUsernameOrPasswordIncorrectEvent
{
    param
    (
        [string]
        [parameter(mandatory=$true)]
        $Domain
    )

    #
    # Differentiate the given domain from the others having the same suffix.
    #
    $Domain = " " + $Domain.ToUpperInvariant()
    $incorrectUsernameOrPasswordCallStackEntryBind = "DirectoryEntry.Bind".ToUpperInvariant()

    #
    # event 611 - failure to resolve a domain controller 
    # 
    $incorrectUsernameOrPasswordCallStackEntry_611 = "DrsConnection.ResolveDomainController".ToUpperInvariant()
    
    #
    # event 612 - failure to get domain naming context information during initialization of password hash sync channel
    #
    $incorrectUsernameOrPasswordCallStackEntry_612 = "DirectoryUtility.GetDomainNamingContextInfo".ToUpperInvariant()


    $domainPasswordSyncErrorEvents = Get-EventLog -LogName "Application" -Source "Directory Synchronization" -After (Get-Date).AddHours(-2) -ErrorAction SilentlyContinue | 
                                     Where-Object { (($_.EventID -eq 611) -and
                                                     ($_.Message.ToUpperInvariant().Contains($Domain)) -and
                                                     ($_.Message.ToUpperInvariant().Contains($incorrectUsernameOrPasswordCallStackEntry_611))  -and
                                                     ($_.Message.ToUpperInvariant().Contains($incorrectUsernameOrPasswordCallStackEntryBind)))  -or

                                                     (($_.EventID -eq 612) -and
                                                      ($_.Message.ToUpperInvariant().Contains($Domain)) -and
                                                      ($_.Message.ToUpperInvariant().Contains($incorrectUsernameOrPasswordCallStackEntry_612))  -and
                                                      ($_.Message.ToUpperInvariant().Contains($incorrectUsernameOrPasswordCallStackEntryBind))) } |
                                     Sort-Object  { $_.TimeWritten } -Descending

    if ($domainPasswordSyncErrorEvents -eq $null)
    {
        Write-Output $null
    }
    else
    {
        Write-Output $domainPasswordSyncErrorEvents[0]
    }
}

#
# Check if password hash sync agent continuously gets RPC errors when connecting to the given domain
#
# Measure - 5+ RPC errors in the last 2 hours for the same domain
#
Function IsPersistentRPCError
{
    param
    (
        [string]
        [parameter(mandatory=$true)]
        $Domain
    )

    #
    # Differentiate the given domain from the others having the same suffix.
    #
    $DomainName = " " + $Domain.ToUpperInvariant()

    #
    # event 611 - RPC Error
    #
    $passwordSyncRPCErrorEntry = "RPC Error".ToUpperInvariant()

    #
    # RPC Error 8453 which is an indicator of AD Connector Account password hash sync permission problem is
    # going to be excluded as it is already tracked.
    #
    $passwordSyncPermissionRPCErrorCode = "8453".ToUpperInvariant()
    $permissionErrorCallStackEntry = "DrsRpcConnection.OnGetChanges".ToUpperInvariant()


    $domainPasswordSyncErrorEvents = Get-EventLog -LogName "Application" -Source "Directory Synchronization" -InstanceId 611 -After (Get-Date).AddHours(-2) -ErrorAction SilentlyContinue | 
                                     Where-Object {($_.Message.ToUpperInvariant().Contains($DomainName)) -and
                                                   ($_.Message.ToUpperInvariant().Contains($passwordSyncRPCErrorEntry)) -and
                                                   !($_.Message.ToUpperInvariant().Contains($passwordSyncPermissionRPCErrorCode)) -and
                                                   !($_.Message.ToUpperInvariant().Contains($permissionErrorCallStackEntry))} |
                                     Sort-Object  { $_.TimeWritten } -Descending
    
    $numberOfRPCErrorsInLastTwoHours = $domainPasswordSyncErrorEvents.Length

    if ($numberOfRPCErrorsInLastTwoHours -gt 4)
    {
        WriteEventLog($EventIdPersistentRPCError)($EventMsgPersistentRPCError -f $Domain)

        $latestDomainRPCErrorEventTime = GetDateTimeLocaleEnUs($domainPasswordSyncErrorEvents[0].TimeGenerated)

        $errorStr = 
        "`tPassword Hash Synchronization agent is continuously getting RPC errors from domain `"$($Domain)`" `n" +
        "`tPlease setup reliable preferred domain controllers. Please see `"Connectivity problems`" section at https://go.microsoft.com/fwlink/?linkid=847231 `n" +
        "`tPlease check 611 error events in the application event logs for details `n" +
        "`tThe latest RPC error event for the domain `"$($Domain)`" is generated at: $latestDomainRPCErrorEventTime UTC `n" +
        "`r`n"

        $errorStr | ReportError
        Write-Output $true
    }
    elseif ($numberOfRPCErrorsInLastTwoHours -gt 0)
    {
        WriteEventLog($EventIdTemporaryRPCError)($EventMsgTemporaryRPCError -f $Domain)

        Write-Output $false
    }
    else
    {
        Write-Output $false
    }
}

#
# Check if password hash sync agent continuously gets LDAP connection errors from the given domain
#
# Measure - 5+ LDAP connection errors in the last 2 hours for the same domain
#
Function IsPersistentLDAPConnectionError
{
    param
    (
        [string]
        [parameter(mandatory=$true)]
        $Domain
    )

    #
    # Differentiate the given domain from the others having the same suffix.
    #
    $DomainName = " " + $Domain.ToUpperInvariant()

    #
    # event 611 - LdapException
    #
    $ldapExceptionEntry = ".LdapException".ToUpperInvariant()

    #
    # event 611 - DirectoryOperationException
    #
    $directoryOperationExceptionEntry = ".DirectoryOperationException".ToUpperInvariant()


    $domainPasswordSyncErrorEvents = Get-EventLog -LogName "Application" -Source "Directory Synchronization" -InstanceId 611 -After (Get-Date).AddHours(-2) -ErrorAction SilentlyContinue | 
                                     Where-Object {($_.Message.ToUpperInvariant().Contains($DomainName)) -and
                                                   (($_.Message.ToUpperInvariant().Contains($ldapExceptionEntry)) -or
                                                    ($_.Message.ToUpperInvariant().Contains($directoryOperationExceptionEntry)))} |
                                     Sort-Object  { $_.TimeWritten } -Descending

    $numberOfLdapConnectionErrorsInLastTwoHours = $domainPasswordSyncErrorEvents.Length

    if ($numberOfLdapConnectionErrorsInLastTwoHours -gt 4)
    {
        WriteEventLog($EventIdPersistentLDAPConnectionError)($EventMsgPersistentLDAPConnectionError -f $Domain)

        $latestDomainLDAPConnectionErrorEventTime = GetDateTimeLocaleEnUs($domainPasswordSyncErrorEvents[0].TimeGenerated)

        $errorStr = 
        "`tPassword Hash Synchronization agent is continuously getting LDAP connection errors from the domain `"$($Domain)`" `n" +
        "`tPlease setup reliable preferred domain controllers. Please see `"Connectivity problems`" section at https://go.microsoft.com/fwlink/?linkid=847231 `n" +
        "`tPlease check 611 error events in the application event logs for details `n" +
        "`tThe latest LDAP Connection error event for the domain `"$($Domain)`" is generated at: $latestDomainLDAPConnectionErrorEventTime UTC `n" +
        "`r`n"

        $errorStr | ReportError

        Write-Output $true
    }
    elseif ($numberOfLdapConnectionErrorsInLastTwoHours -gt 0)
    {
        WriteEventLog($EventIdTemporaryLDAPConnectionError)($EventMsgTemporaryLDAPConnectionError -f $Domain)

        Write-Output $false
    }
    else
    {
        Write-Output $false
    }
}

#
# Check if password hash sync agent gets CryptographicException
# 
Function GetLatestCryptographicExceptionEvent
{
    param
    (
        [string]
        [parameter(mandatory=$true)]
        $Domain
    )

    #
    # Differentiate the given domain from the others having the same suffix.
    #
    $Domain = " " + $Domain.ToUpperInvariant()

    #
    # event 611 - CryptographicException
    #
    $cryptographicExceptionEntry = ".CryptographicException".ToUpperInvariant()

    $domainPasswordSyncErrorEvents = Get-EventLog -LogName "Application" -Source "Directory Synchronization" -InstanceId 611 -After (Get-Date).AddHours(-2) -ErrorAction SilentlyContinue | 
                                     Where-Object {($_.Message.ToUpperInvariant().Contains($Domain)) -and
                                                   ($_.Message.ToUpperInvariant().Contains($cryptographicExceptionEntry))} |
                                     Sort-Object  { $_.TimeWritten } -Descending

    if ($domainPasswordSyncErrorEvents -eq $null)
    {
        Write-Output $null
    }
    else
    {
        Write-Output $domainPasswordSyncErrorEvents[0]
    }
}

#
# Check password hash sync agent internal errors
#
# Most failing calls: FimNotificationManager.GetRetryObjects, FimNotificationManager.UpdateRetryStatus
# 
Function GetLatestInternalErrorEvent
{
    param
    (
        [string]
        [parameter(mandatory=$true)]
        $Domain
    )

    #
    # Differentiate the given domain from the others having the same suffix.
    #
    $Domain = " " + $Domain.ToUpperInvariant()

    $passwordSyncInternalFailureCallStackEntry1_611 = "FimNotificationManager.GetRetryObjects".ToUpperInvariant()
    $passwordSyncInternalFailureCallStackEntry2_611 = "FimNotificationManager.UpdateRetryStatus".ToUpperInvariant()

    $domainPasswordSyncErrorEvents = Get-EventLog -LogName "Application" -Source "Directory Synchronization" -InstanceId 611 -After (Get-Date).AddHours(-2) -ErrorAction SilentlyContinue | 
                                     Where-Object {($_.Message.ToUpperInvariant().Contains($Domain)) -and
                                                   (($_.Message.ToUpperInvariant().Contains($passwordSyncInternalFailureCallStackEntry1_611)) -or
                                                   ($_.Message.ToUpperInvariant().Contains($passwordSyncInternalFailureCallStackEntry2_611)))} |
                                     Sort-Object  { $_.TimeWritten } -Descending


    if ($domainPasswordSyncErrorEvents -eq $null)
    {
        Write-Output $null
    }
    else
    {
        Write-Output $domainPasswordSyncErrorEvents[0]
    }
}

#
# Check if password hash sync agent fails on AWS API call to push password changes to AAD Tenant OR to ping AAD Tenant.
#
# Checks 652 and 655 error events
#
Function CheckLatestPasswordSyncAWSCallFailureEvents
{
    $passwordSyncCloudConfigNotActivatedEntry = "Error Code: 90".ToUpperInvariant()
    $identitySyncCloudConfigNotActivatedEntry = "Error Code: 15".ToUpperInvariant()
    $accessToAzureActiveDirectoryDeniedEntry  = "Error Code: 7".ToUpperInvariant()
    $endpointNotFoundExceptionEntry           = "EndpointNotFoundException".ToUpperInvariant()
    $securityNegotiationExceptionEntry        = "SecurityNegotiationException".ToUpperInvariant()
    
    #
    # Adal Service Exception and related errors
    #
    $adalServiceExceptionEntry                = ".AdalServiceException".ToUpperInvariant()
    $userRealmDiscoveryFailedEntry            = "user_realm_discovery_failed".ToUpperInvariant()
    $stsErrorCodeAccountMustBeAddedToTenant   = "AADSTS50034".ToUpperInvariant()
    $stsErrorCodeOldPasswordUsed              = "AADSTS50054".ToUpperInvariant()
    $stsErrorCodeAccountDisabled              = "AADSTS50057".ToUpperInvariant()
    $stsErrorCodeInvalidUsernameOrPassword    = "AADSTS50126".ToUpperInvariant()
    $stsErrorCodeTenantNotFound               = "AADSTS90002".ToUpperInvariant()

    $passwordSyncBatchAWSCallFailureEvents = Get-EventLog -LogName "Application" -Source "Directory Synchronization" -InstanceId 652 -After (Get-Date).AddHours(-2) -ErrorAction SilentlyContinue | 
                                             Sort-Object  { $_.TimeWritten } -Descending

    $passwordSyncPingAWSCallFailureEvents  = Get-EventLog -LogName "Application" -Source "Directory Synchronization" -InstanceId 655 -After (Get-Date).AddHours(-2) -ErrorAction SilentlyContinue | 
                                             Sort-Object  { $_.TimeWritten } -Descending

    
    if ($passwordSyncBatchAWSCallFailureEvents -ne $null)
    {
        WriteEventLog($EventIdPwdSyncBatchAWSFailure)($EventMsgPwdSyncBatchAWSFailure)

        $pwdSyncBatchAWSCallFailureTime = GetDateTimeLocaleEnUs($passwordSyncBatchAWSCallFailureEvents[0].TimeGenerated)

        $errorStr =
        "Password Hash Synchronization agent had an error while pushing password changes to AAD tenant at: $pwdSyncBatchAWSCallFailureTime UTC `n" +
        "Please make sure AAD connector account is added to AAD Tenant, and username and password for this account are valid. `n" +
        "Please check 652 error events in the application event logs for details `n" +
        "`r`n"

        $errorStr | ReportError

        $errorMessage = $passwordSyncBatchAWSCallFailureEvents[0].Message.ToUpperInvariant();

        if ($errorMessage.Contains($passwordSyncCloudConfigNotActivatedEntry))
        {
            WriteEventLog($EventIdPwdSyncBatchAWSFailurePwdSyncCloudConfigNotActivated)($EventMsgPwdSyncBatchAWSFailurePwdSyncCloudConfigNotActivated)             
        }
        elseif ($errorMessage.Contains($identitySyncCloudConfigNotActivatedEntry))
        {
            WriteEventLog($EventIdPwdSyncBatchAWSFailureIdentitySyncCloudConfigNotActivated)($EventMsgPwdSyncBatchAWSFailureIdentitySyncCloudConfigNotActivated)             
        }
        elseif ($errorMessage.Contains($accessToAzureActiveDirectoryDeniedEntry))
        {
            WriteEventLog($EventIdPwdSyncBatchAWSFailureAADAccessDenied)($EventMsgPwdSyncBatchAWSFailureAADAccessDenied)             
        }
        elseif ($errorMessage.Contains($endpointNotFoundExceptionEntry))
        {
            WriteEventLog($EventIdPwdSyncBatchAWSFailureEndpointNotFoundException)($EventMsgPwdSyncBatchAWSFailureEndpointNotFoundException)
        }
        elseif ($errorMessage.Contains($adalServiceExceptionEntry))
        {
            WriteEventLog($EventIdPwdSyncBatchAWSFailureAdalServiceException)($EventMsgPwdSyncBatchAWSFailureAdalServiceException)

            if ($errorMessage.Contains($userRealmDiscoveryFailedEntry))
            {
                WriteEventLog($EventIdPwdSyncBatchAWSFailureAdalServiceExUserRealmDiscoveryFailed)($EventMsgPwdSyncBatchAWSFailureAdalServiceExUserRealmDiscoveryFailed)
            }
            elseif ($errorMessage.Contains($stsErrorCodeAccountMustBeAddedToTenant))
            {
                WriteEventLog($EventIdPwdSyncBatchAWSFailureAdalServiceExAccountMustBeAddedToTenant)($EventMsgPwdSyncBatchAWSFailureAdalServiceExAccountMustBeAddedToTenant)
            }
            elseif ($errorMessage.Contains($stsErrorCodeOldPasswordUsed))
            {
                WriteEventLog($EventIdPwdSyncBatchAWSFailureAdalServiceExOldPasswordUsed)($EventMsgPwdSyncBatchAWSFailureAdalServiceExOldPasswordUsed)
            }
            elseif ($errorMessage.Contains($stsErrorCodeAccountDisabled))
            {
                WriteEventLog($EventIdPwdSyncBatchAWSFailureAdalServiceExAccountDisabled)($EventMsgPwdSyncBatchAWSFailureAdalServiceExAccountDisabled)
            }
            elseif ($errorMessage.Contains($stsErrorCodeInvalidUsernameOrPassword))
            {
                WriteEventLog($EventIdPwdSyncBatchAWSFailureAdalServiceExInvalidUsernameOrPwd)($EventMsgPwdSyncBatchAWSFailureAdalServiceExInvalidUsernameOrPwd)
            }
            elseif ($errorMessage.Contains($stsErrorCodeTenantNotFound))
            {
                WriteEventLog($EventIdPwdSyncBatchAWSFailureAdalServiceExTenantNotFound)($EventMsgPwdSyncBatchAWSFailureAdalServiceExTenantNotFound)
            }
        }
        elseif ($errorMessage.Contains($securityNegotiationExceptionEntry))
        {
            WriteEventLog($EventIdPwdSyncBatchAWSFailureSecurityNegotiationException)($EventMsgPwdSyncBatchAWSFailureSecurityNegotiationException)
        }
    }

    if ($passwordSyncPingAWSCallFailureEvents -ne $null)
    {
        WriteEventLog($EventIdPwdSyncPingAWSFailure)($EventMsgPwdSyncPingAWSFailure)

        $pwdSyncPingAWSCallFailureTime = GetDateTimeLocaleEnUs($passwordSyncPingAWSCallFailureEvents[0].TimeGenerated)

        $errorStr = 
        "Password Hash Synchronization agent had an error while pinging AAD tenant at: $pwdSyncPingAWSCallFailureTime UTC `n" +
        "Please make sure AAD connector account is added to AAD Tenant, and username and password for this account are valid. `n" +
        "Please check 655 error events in the application event logs for details `n" +
        "`r`n"
        
        $errorStr | ReportError

        $errorMessage = $passwordSyncPingAWSCallFailureEvents[0].Message.ToUpperInvariant();

        if ($errorMessage.Contains($passwordSyncCloudConfigNotActivatedEntry))
        {
            WriteEventLog($EventIdPwdSyncPingAWSFailurePwdSyncCloudConfigNotActivated)($EventMsgPwdSyncPingAWSFailurePwdSyncCloudConfigNotActivated)             
        }
        elseif ($errorMessage.Contains($identitySyncCloudConfigNotActivatedEntry))
        {
            WriteEventLog($EventIdPwdSyncPingAWSFailureIdentitySyncCloudConfigNotActivated)($EventMsgPwdSyncPingAWSFailureIdentitySyncCloudConfigNotActivated)             
        }
        elseif ($errorMessage.Contains($accessToAzureActiveDirectoryDeniedEntry))
        {
            WriteEventLog($EventIdPwdSyncPingAWSFailureAADAccessDenied)($EventMsgPwdSyncPingAWSFailureAADAccessDenied)             
        }
        elseif ($errorMessage.Contains($endpointNotFoundExceptionEntry))
        {
            WriteEventLog($EventIdPwdSyncPingAWSFailureEndpointNotFoundException)($EventMsgPwdSyncPingAWSFailureEndpointNotFoundException)
        }
        elseif ($errorMessage.Contains($adalServiceExceptionEntry))
        {
             WriteEventLog($EventIdPwdSyncPingAWSFailureAdalServiceException)($EventMsgPwdSyncPingAWSFailureAdalServiceException)

            if ($errorMessage.Contains($userRealmDiscoveryFailedEntry))
            {
                WriteEventLog($EventIdPwdSyncPingAWSFailureAdalServiceExUserRealmDiscoveryFailed)($EventMsgPwdSyncPingAWSFailureAdalServiceExUserRealmDiscoveryFailed)
            }
            elseif ($errorMessage.Contains($stsErrorCodeAccountMustBeAddedToTenant))
            {
                WriteEventLog($EventIdPwdSyncPingAWSFailureAdalServiceExAccountMustBeAddedToTenant)($EventMsgPwdSyncPingAWSFailureAdalServiceExAccountMustBeAddedToTenant)
            }
            elseif ($errorMessage.Contains($stsErrorCodeOldPasswordUsed))
            {
                WriteEventLog($EventIdPwdSyncPingAWSFailureAdalServiceExOldPasswordUsed)($EventMsgPwdSyncPingAWSFailureAdalServiceExOldPasswordUsed)
            }
            elseif ($errorMessage.Contains($stsErrorCodeAccountDisabled))
            {
                WriteEventLog($EventIdPwdSyncPingAWSFailureAdalServiceExAccountDisabled)($EventMsgPwdSyncPingAWSFailureAdalServiceExAccountDisabled)
            }
            elseif ($errorMessage.Contains($stsErrorCodeInvalidUsernameOrPassword))
            {
                WriteEventLog($EventIdPwdSyncPingAWSFailureAdalServiceExInvalidUsernameOrPwd)($EventMsgPwdSyncPingAWSFailureAdalServiceExInvalidUsernameOrPwd)
            }
            elseif ($errorMessage.Contains($stsErrorCodeTenantNotFound))
            {
                WriteEventLog($EventIdPwdSyncPingAWSFailureAdalServiceExTenantNotFound)($EventMsgPwdSyncPingAWSFailureAdalServiceExTenantNotFound)
            }
        }
        elseif ($errorMessage.Contains($securityNegotiationExceptionEntry))
        {
            WriteEventLog($EventIdPwdSyncPingAWSFailureSecurityNegotiationException)($EventMsgPwdSyncPingAWSFailureSecurityNegotiationException)
        }
    }
}

#
# Check if verbose logging is turned on for password hash sync
#
Function CheckVerboseLoggingForPHS
{
    $adSyncRegKey = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\AD Sync"
    $adSyncPath = $adSyncRegKey.Location
    $adSyncConfigurationPath = [System.IO.Path]::Combine($adSyncPath, "Bin\miiserver.exe.config")

    [xml]$adSyncConfiguration = Get-Content $adSyncConfigurationPath
    $passwordSyncLogging = $adSyncConfiguration.configuration.'system.diagnostics'.sources.source | ? { $_.name -eq 'passwordSync'}
    
    if($passwordSyncLogging -and $passwordSyncLogging.switchValue -eq 'Verbose')
    {
        ReportWarning "Verbose logging is enabled for Password Hash Synchronization, this can very quickly fill up a disk. Review configuration at '$adSyncConfigurationPath'."
    }
}


Function ReportPartitionPasswordSyncState
{
    param
    (
        [Microsoft.IdentityManagement.PowerShell.ObjectModel.PartitionPasswordSyncState]
        [parameter(mandatory=$true)]
        $PartitionPasswordSyncState
    )

    $partitionPasswordSyncLastCycleStatus = $partitionPasswordSyncState.PasswordSyncLastCycleStatus.ToString()
    
    $culture = New-Object System.Globalization.CultureInfo 'en-us'
    $partitionPasswordSyncLastSuccessfulCycleStartDateTime = $partitionPasswordSyncState.PasswordSyncLastSuccessfulCycleStartTimestamp.ToString($culture)
    $partitionPasswordSyncLastSuccessfulCycleEndDateTime = $partitionPasswordSyncState.PasswordSyncLastSuccessfulCycleEndTimestamp.ToString($culture)

    if ($partitionPasswordSyncLastCycleStatus -eq "None")
    {
        "`tPassword Hash Synchronization agent has never attempted to synchronize passwords from this directory partition." | ReportWarning
    }
    elseif ($partitionPasswordSyncLastCycleStatus -eq "InProgress")
    {
        "`tPassword Hash Synchronization agent is currently synchronizing passwords from this directory partition." | ReportWarning

        $partitionPasswordSyncLastCycleStartDateTime = $partitionPasswordSyncState.PasswordSyncLastCycleStartTimestamp.ToString($culture)
        "`tPassword Hash Synchronization is in progress and started at: $partitionPasswordSyncLastCycleStartDateTime UTC" | ReportWarning
    }
    elseif ($partitionPasswordSyncState.PasswordSyncLastSuccessfulCycleStartTimestamp.Year -eq 1)
    {
        "`tPassword Hash Synchronization agent has never successfully completed synchronizing passwords from this directory partition." | ReportWarning
    }
    else
    {
        "`tLast successful attempt to synchronize passwords from this directory partition started at: $partitionPasswordSyncLastSuccessfulCycleStartDateTime UTC and ended at: $partitionPasswordSyncLastSuccessfulCycleEndDateTime UTC" |
        ReportOutput -PropertyName "Last successfull Passwords Sync from this directory partition Start Time " -PropertyValue "$partitionPasswordSyncLastSuccessfulCycleStartDateTime UTC"
        ReportOutput -PropertyName "Last successfull Passwords Sync from this directory partition End Time" -PropertyValue "$partitionPasswordSyncLastSuccessfulCycleEndDateTime UTC"
    }
}

Function DiagnoseADConnectivity
{
    param
    (
        [Microsoft.IdentityManagement.PowerShell.ObjectModel.Connector]
        [parameter(mandatory=$true)]
        $ADConnector
    )

    Write-Host "`r`n"
    Write-Host "`tDirectory Partitions:"
    Write-Host "`t====================="

    if ($ADConnector.Partitions.Count -eq 0)
    {
        "`tNo directory partition is found for AD Connector - $($ADConnector.Name)" | ReportError
        Write-Host "`r`n"
        return
    }

    #
    # Get password hash sync state for all directory partitions.
    #
    $partitionPasswordSyncStateList = Get-ADSyncPartitionPasswordSyncState

    foreach ($partition in $ADConnector.Partitions)
    {
        Write-Host "`tDirectory Partition - $($partition.Name)"

        # Check if directory partition is a domain
        if (-not $partition.IsDomain)
        {
            "`tDirectory partition `"$($partition.Name)`" is not a domain" | Write-Host -fore Yellow
            Write-Host "`r`n"

            if ($isNonInteractiveMode)
            {
                continue
            }

            # Check if corresponding AD partition is a domain
            $adObject = Search-ADSyncDirectoryObjects -AdConnectorId $ADConnector.Identifier -LdapFilter "(distinguishedName=$($partition.DN))" -SearchScope Subtree -SizeLimit 1

            if ($adObject -ne $null -and $adObject.Count -gt 0 -and (IsObjectTypeMatch($adObject[0])("domain")))
            {
                $domainChoiceOptions = [System.Management.Automation.Host.ChoiceDescription[]] @("&Yes", "&No")
                $setDomainFlag = !($host.UI.PromptForChoice("Set domain flag on partition", "To avoid password sync issues it is recommended that the domain flag for the partition be set to true in the Connector configuration. Is it okay to set it to true now?", $domainChoiceOptions, 0))

                if ($setDomainFlag)
                {
                    try
                    {
                        # Set IsDomain flag in AD Connector Partition
                        $adPartionI = $ADConnector.Partitions.IndexOf($partition)
                        $ADConnector.Partitions[$adPartionI].IsDomain = $true

                        # Adding AD Connector configuration
                        Add-ADSyncConnector -Connector $ADConnector
                        Write-Output "INFO: AD Partition `"$($partition.Name)`" set as Domain partition successfully."
                    }
                    catch
                    {
                        Write-Error "An error occurred setting the domain flag on the partition: $($_.Exception.Message)"
                        continue
                    }
                }
                else
                {
                    continue
                }
            }
            else
            {
                continue
            }
        }
        
        # Check if directory partition is selected for synchronization
        if (-not $partition.Selected)
        {
            "`tDomain `"$($partition.Name)`" is excluded from synchronization" | Write-Host -fore Yellow
            Write-Host "`r`n"
            continue
        }

        #
        # Check if password hash sync agent continuously gets domain failures
        #
        IsPersistentDomainFailure($partition.Name)

        #
        # Check if password hash sync agent fails to RESOLVE a domain controller for the current directory partition 
        # since it is unable to retrieve source domain information OR unable to resolve source host name
        #
        $unableToResolveDomainControllerEvent = GetLatestFailureToResolveDomainControllerEvent($partition.Name)
        
        if ($unableToResolveDomainControllerEvent -ne $null)
        {
            WriteEventLog($EventIdCannotResolveDomainController)($EventMsgCannotResolveDomainController -f $partition.Name)

            $unableToResolveDomainControllerIssueTime = GetDateTimeLocaleEnUs($unableToResolveDomainControllerEvent.TimeGenerated)
    
            $errString = "`tPassword Hash Synchronization agent had a problem to resolve a domain controller in the domain `"$($partition.Name)`" at: $unableToResolveDomainControllerIssueTime UTC `n" +
            "`tPlease check 611 error events in the application event logs for details `n" +
            "`r`n"
            $errString | ReportError

        }

        #
        # Check if password hash sync agent fails to LOCATE a domain controller for the current directory partition
        # after successfully retrieving the source domain information and resolving source host name
        #
        $unableToLocateDomainControllerEvent = GetLatestFailureToLocateDomainControllerEvent($partition.Name)

        if ($unableToLocateDomainControllerEvent -ne $null)
        {
            WriteEventLog($EventIdCannotLocateDomainController)($EventMsgCannotLocateDomainController -f $partition.Name)

            $unableToLocateDomainControllerIssueTime = GetDateTimeLocaleEnUs($unableToLocateDomainControllerEvent.TimeGenerated)

            $errString = 
            "`tPassword Hash Synchronization agent had a problem to locate a domain controller in the domain `"$($partition.Name)`" at: $unableToLocateDomainControllerIssueTime UTC `n" +
            "`tPlease setup reliable preferred domain controllers. Please see `"Connectivity problems`" section at https://go.microsoft.com/fwlink/?linkid=847231 `n" +
            "`tPlease check 611 error events in the application event logs for details `n" +
            "`r`n"

            $errString | ReportError

        }

        #
        # Check if AD Connector account has incorrect username or password problem for the directory partition
        #
        $incorrectUsernameOrPasswordEvent = GetADConnectorAccountLatestUsernameOrPasswordIncorrectEvent($partition.Name)

        if ($incorrectUsernameOrPasswordEvent -ne $null)
        {
            WriteEventLog($EventIdCannotBindToDomainController)($EventMsgCannotBindToDomainController -f $partition.Name)

            $incorrectUsernameOrPasswordIssueTime = GetDateTimeLocaleEnUs($incorrectUsernameOrPasswordEvent.TimeGenerated)

            $errString =
            "`tPassword Hash Synchronization agent had a problem about connecting to a domain controller in the domain `"$($partition.Name)`" at: $incorrectUsernameOrPasswordIssueTime UTC `n" +
            "`tPlease make sure AD Connector account username and password are correct `n" +
            "`tIn case the problem continues, then please setup reliable preferred domain controllers. Please see `"Connectivity problems`" section at https://go.microsoft.com/fwlink/?linkid=847231 `n" +
            "`tPlease check 611 error events in the application event logs for details `n" +
            "`r`n"

            $errString | ReportError
        }

        # Check if AD Connector account has password hash sync permission problem for the directory partition
        $passwordSyncPermissionFailedEvent = GetADConnectorAccountLatestPasswordSyncPermissionFailedEvent($partition.Name)
        
        if ($passwordSyncPermissionFailedEvent -ne $null)
        {
            WriteEventLog($EventIdConnectorAccountPwdSyncPermissionFailed)($EventMsgConnectorAccountPwdSyncPermissionFailed -f $partition.Name)

            $passwordSyncPermissionFailTime = GetDateTimeLocaleEnUs($passwordSyncPermissionFailedEvent.TimeGenerated)

            $errString = 
            "`tAD Connector account had a Password Hash Synchronization permission problem for the domain `"$($partition.Name)`" at: $passwordSyncPermissionFailTime UTC `n" +
            "`tPlease see: https://go.microsoft.com/fwlink/?linkid=847234 `n" +
            "`tPlease check 611 error events in the application event logs for details `n" +
            "`r`n"
            
            $errString | ReportError
        }

        #
        # Check if password hash sync agent fails by repeated RPC errors while connecting to a domain controller
        #
        IsPersistentRPCError($partition.Name)

        #
        # Check if password hash sync agent fails by repeated LDAP connection errors while connecting to a domain controller
        #
        IsPersistentLDAPConnectionError($partition.Name)

        #
        # Check if password hash sync agent fails by CryptographicException
        #
        $cryptographicExceptionEvent = GetLatestCryptographicExceptionEvent($partition.Name)

        if ($cryptographicExceptionEvent -ne $null)
        {
            WriteEventLog($EventIdPasswordSyncCryptographicException)($EventMsgPasswordSyncCryptographicException -f $partition.Name)

            $cryptographicExceptionIssueTime = GetDateTimeLocaleEnUs($cryptographicExceptionEvent.TimeGenerated)

            $errString = 
            "`tPassword Hash Synchronization agent had System.Security.Cryptography.CryptographicException for the domain `"$($partition.Name)`" at: $cryptographicExceptionIssueTime UTC `n" +
            "`tPlease check 611 error events in the application event logs for details `n" +
            "`r`n"

            $errString | ReportError
        }

        #
        # Check if password hash sync agent fails by an internal exception
        #
        $internalErrorEvent = GetLatestInternalErrorEvent($partition.Name)

        if ($internalErrorEvent -ne $null)
        {
            WriteEventLog($EventIdPasswordSyncInternalError)($EventMsgPasswordSyncInternalError -f $partition.Name)
        }
        
        #
        # Find the password hash sync state for the given directory partition (domain) using its distinguished name.
        #
        $partitionPasswordSyncState = $partitionPasswordSyncStateList | Where-Object{$_.DN -eq $partition.DN}

        # Report password hash sync state for the directory partition.
        ReportPartitionPasswordSyncState($partitionPasswordSyncState)

        # Check if DC connection settings is configured to use only preferred domain controllers
        $onlyUsePreferredDC = ($partition.Parameters["dc-failover"].Value -eq 0)

        "`tOnly Use Preferred Domain Controllers: $onlyUsePreferredDC" |
        ReportOutput -PropertyName "Use Preferred Domain Controllers" -PropertyValue $onlyUsePreferredDC

        if (-not $onlyUsePreferredDC)
        {
            Write-Host "`tChecking connectivity to the domain..."

            # Test connectivity to domain
            $isDomainReachable = IsDomainReachable($partition.Name)
            
            if ($isDomainReachable -eq $true)
            {
                "`tDomain `"$($partition.Name)`" is reachable" | ReportOutput 
            }
            else
            {
                WriteEventLog($EventIdDomainIsNotReachable)($EventMsgDomainIsNotReachable -f ($partition.Name))

                "`tDomain `"$($partition.Name)`" is not reachable" | ReportError            
            }

            Write-Host "`r`n"
        }
        else
        {
            Write-Host "`r`n"
            Write-Host "`t`tPreferred Domain Controllers:"
            Write-Host "`t`t============================="

            #
            # Test connectivity to preferred domain controllers
            # Success : querying at least one PDC successfully 
            # Failure : query fails for all PDCs
            #

            $isAllPDCsFailed = $true

            foreach ($preferredDC in $partition.PreferredDCs)
            {
                Write-Host "`t`tChecking connectivity to the preferred domain controller `"$preferredDC`"..."

                $isPreferredDCReachable = IsDomainReachable($preferredDC)

                if ($isPreferredDCReachable -eq $true)
                {
                    $isAllPDCsFailed = $false
                    "`t`tPreferred domain controller `"$preferredDC`" is reachable" | ReportOutput 
                    Write-Host "`r`n"
                    break
                }
                else
                {
                    "`t`tPreferred domain controller `"$preferredDC`" is not reachable" | ReportError
                    Write-Host "`r`n"
                }
            }

            if ($isAllPDCsFailed -eq $true)
            {
                WriteEventLog($EventIdDomainIsNotReachable)($EventMsgDomainIsNotReachable -f ($partition.Name))

                "`tDomain `"$($partition.Name)`" is not reachable" | ReportError
            }
            else
            {
                "`tDomain `"$($partition.Name)`" is reachable" | ReportOutput 
            }

            Write-Host "`r`n"
        }
    }
}

Function DiagnosePasswordSyncSingleObject
{
    param
    (
        [string]
        [parameter(mandatory=$false)]
        $ADConnectorName,

        [string]
        [parameter(mandatory=$false)]
        $DistinguishedName
    )

    if ([string]::IsNullOrEmpty($ADConnectorName) -and [string]::IsNullOrEmpty($DistinguishedName))
    {
        DiagnosePasswordSyncSingleObjectHelper
    }
    elseif ([string]::IsNullOrEmpty($ADConnectorName))
    {
        DiagnosePasswordSyncSingleObjectHelper -DistinguishedName $DistinguishedName
    }
    elseif ([string]::IsNullOrEmpty($DistinguishedName))
    {
        DiagnosePasswordSyncSingleObjectHelper -ADConnectorName $ADConnectorName
    }
    else
    {
        DiagnosePasswordSyncSingleObjectHelper -ADConnectorName $ADConnectorName -DistinguishedName $DistinguishedName
    }
    
    Write-Host "`r`n"

    if (-not $isNonInteractiveMode)
    {
        do
        {
            $answer = Read-Host "Did you find Password Hash Sync Single Object Diagnostics helpful? [y/n]"
        } 
        while(($answer -ne 'y') -and ($answer -ne 'Y') -and ($answer -ne 'n') -and ($answer -ne 'N'))

        WriteEventLog($EventIdIsPwdSyncSingleObjectDiagnosticsHelpful)($EventMsgIsPwdSyncSingleObjectDiagnosticsHelpful -f ($answer))
    }
}

#
# Diagnose password hash sync single object problems
#
# The object is specified by corresponding AD Connector Name and Distinguished Name of the object.
#
Function DiagnosePasswordSyncSingleObjectHelper
{
    param
    (
        [string]
        [parameter(mandatory=$false)]
        $ADConnectorName,

        [string]
        [parameter(mandatory=$false)]
        $DistinguishedName
    )

    WriteEventLog($EventIdSingleObjectDiagnosticsRun)($EventMsgSingleObjectDiagnosticsRun)

    Write-Host "`r`n"

    Write-Host "==========================================================================="
    Write-Host "=                                                                         ="
    Write-Host "=         Password Hash Synchronization Single Object Diagnostics         ="
    Write-Host "=                                                                         ="
    Write-Host "==========================================================================="

    $adConnectors = GetADConnectors
    if ($adConnectors -eq $null)
    {
        "No AD Connector is found. Password Hash Synchronization does not work in the absence of AD Connectors." | ReportError
        return        
    }

    if ([string]::IsNullOrEmpty($ADConnectorName) -or [string]::IsNullOrEmpty($DistinguishedName))
    {
        $adConnectorName = [string]::Empty
        $dn = [string]::Empty
    }
    else
    {
        $adConnectorName = $ADConnectorName
        $dn = $DistinguishedName
    }

    #
    # Get AD Connector Name as input
    # Prompt user again and provide a list of AD Connectors in case of wrong input
    #
    while ($true)
    {
        while ([string]::IsNullOrEmpty($adConnectorName))
        {
            Write-Host "`r`n"

            Write-Host "List of AD Connectors:"
            Write-Host "----------------------"

            foreach ($adConnector in $adConnectors)
            {
                Write-Host $adConnector.Name                
            }

            if ($adConnectors.length -eq 1)
            {
                $ADConnectorName = $adConnectors[0].Name
            }
            else
            {
                Write-Host "`r`n"

                $ADConnectorName = Read-Host "Please enter AD Connector Name"
            }
        }

        $adConnector = GetADConnectorByName($adConnectorName)

        if ($adConnector -eq $null)
        {
            ReportWarning "There is no AD Connector with name `"$adConnectorName`". Please try again!"
            $adConnectorName = [string]::Empty
            if ($isNonInteractiveMode)
            {
                return
            }
        }
        else
        {
            break
        }
    }

    # Get password hash sync configuration for the specified AD Connector
    $adConnectorPasswordSyncConfig = GetADConnectorPasswordSyncConfiguration($adConnector)

    # Check if password hash sync is enabled for the AD connector.
    if ($adConnectorPasswordSyncConfig.Enabled -eq $true)
    {
        "Password Hash Synchronization is enabled for AD Connector - $adConnectorName" | ReportOutput
    }
    else
    {
        WriteEventLog($EventIdSingleObjectConnectorDisabled)($EventMsgSingleObjectConnectorDisabled -f $adConnectorName)

        $errString = 
        "Password Hash Synchronization is disabled for AD Connector - $adConnectorName `n" +
        "Please enable Password Hash Synchronization from AADConnect Wizard in order to sync passwords"

        $errString | ReportError -PropertyName 'AD connector Password hash Sync' -PropertyValue 'Disabled'
        return
    }

    Write-Host "`r`n"

    while ($true)
    {
        while ([string]::IsNullOrEmpty($dn))
        {
            # Get AD connector space object Distinguished Name as input
            $dn = Read-Host "Please enter AD connector space object Distinguished Name"
        }
        
        #
        # Check if the object with the given Distinguished Name is in the AD connector space
        #
        $adCsObject = GetCSObject($adConnectorName)($dn)
    
        if ($adCsObject -eq $null)
        {
            "The object is not found in the AD connector space - $ADConnectorName" | ReportError
            Write-Host "`r`n"

            $dn = [string]::Empty

            if ($isNonInteractiveMode)
            {
                return
            }
            do
            {
                $confirmation = Read-Host "Would you like to try another Distinguished Name? [y/n]"

                if (($confirmation -eq 'n') -or ($confirmation -eq 'N'))
                {
                    Write-Host "`r`n"
                    return
                }
            } while(($confirmation -ne 'y') -or ($confirmation -ne 'Y'))

            Write-Host "`r`n"
        }
        else
        {
            Write-Host "`r`n"
            "The object is available in the AD connector space - $adConnectorName" | ReportOutput 
            break
        }
    }    
    
    #
    # Check if the object has a link to the metaverse
    #
    if ($adCsObject.IsConnector -eq $true)
    {
        "The object is a connector, it has a link to the metaverse" | ReportOutput 
    }
    else
    {
        WriteEventLog($EventIdSingleObjectDisconnector)($EventMsgSingleObjectDisconnector -f ($adConnectorName, $dn))

        "The object is a disconnector, it does not have a link to the metaverse" | ReportError
        return
    }
    
    #
    # Check if the object is synced to the AAD Connector
    #
    $aadConnector = GetAADConnector
    if ($aadConnector -eq $null)
    {
        "No AAD Connector is found. Password Hash Synchronization does not work in the absence of AAD Connector." | ReportError
        return
    }

    # Get metaverse object
    $mvObject = GetMVObjectByIdentifier($adCsObject.ConnectedMVObjectId)

    # Get target AAD connector space object identifier
    $aadCsObjectId = GetTargetCSObjectId($mvObject)($aadConnector.Identifier)
    if ($aadCsObjectId -eq $null)
    {
        WriteEventLog($EventIdSingleObjectNotSyncedToAADCS)($EventMsgSingleObjectNotSyncedToAADCS -f ($adConnectorName, $dn))

        "The object is not synced to the AAD connector space" | ReportError
        return
    }

    # Get target AAD connector space object
    $aadCsObject = GetCSObjectByIdentifier($aadCsObjectId)
    
    if ($aadCsObject -eq $null)
    {
        WriteEventLog($EventIdSingleObjectNotSyncedToAADCS)($EventMsgSingleObjectNotSyncedToAADCS -f ($adConnectorName, $dn))

        "The object is not synced to the AAD connector space" | ReportError
        return
    }
    else
    {
        "The object is synced to the AAD connector space" | ReportOutput 
    }

    Write-Host "`r`n"

    #
    # Check lineage of AD connector space object
    #
    $adCsObjectPasswordSyncRule = GetCsObjectPasswordSyncRule($adCsObject)

    if ($adCsObjectPasswordSyncRule -eq $null)
    {
        WriteEventLog($EventIdSingleObjectNoADPwdSyncRule)($EventMsgSingleObjectNoADPwdSyncRule -f ($adConnectorName, $dn))

        "There is no Password Hash Synchronization rule for AD connector space object" | ReportError

        # Check if AD connector space object has synchronization error
        if ($adCsObject.HasSyncError -eq $true)
        {
            "The AD connector space object has synchronization error" | ReportError 
        }

        "Please check synchronization rules or see: https://go.microsoft.com/fwlink/?linkid=847233" | Write-Host -fore Red

        return    
    }
    else
    {
        "Password Hash Synchronization rule is found for AD connector space object" | ReportOutput 
        $adCsObjectPasswordSyncRule | select Name, Direction, LinkType, EnablePasswordSync | ft -AutoSize | Out-String | Write-Host
    }
    
    #
    # Check lineage of AAD connector space object
    #
    $aadCsObjectPasswordSyncRule = GetCsObjectPasswordSyncRule($aadCsObject)

    if ($aadCsObjectPasswordSyncRule -eq $null)
    {
        WriteEventLog($EventIdSingleObjectNoAADPwdSyncRule)($EventMsgSingleObjectNoAADPwdSyncRule -f ($adConnectorName, $dn))

        "There is no Password Hash Synchronization rule for target AAD connector space object" | ReportError

        # Check if target AAD connector space object has synchronization error
        if ($aadCsObject.HasSyncError -eq $true)
        {
            "The target AAD connector space object has synchronization error" | ReportError
        }

        "Please check synchronization rules or see: https://go.microsoft.com/fwlink/?linkid=847233" | Write-Host -fore Red

        return
    }
    else
    {
        "Password Hash Synchronization rule is found for target AAD connector space object" | ReportOutput 
        $aadCsObjectPasswordSyncRule | select Name, Direction, LinkType, EnablePasswordSync | ft -AutoSize | Out-String | Write-Host    
    }

    #
    # Check CS Object Log Entry
    #
    $logEntryCount = 1
    $adCsObjectLogEntries = GetCSObjectLog($adCsObject)($logEntryCount)

    if ($adCsObjectLogEntries -eq $null)
    {
        WriteEventLog($EventIdSingleObjectNoPwdHistory)($EventMsgSingleObjectNoPwdHistory -f ($adConnectorName, $dn))

        $warningString = 
        "Password Hash Synchronization agent does not have any password change history for the specified object `n" +
        "Password change history is purged once in a week."
        
        $warningString | ReportWarning

        Write-Host "`r`n"
        return
    }

    $adCsObjectLatestLogEntry = $adCsObjectLogEntries[0]
    $adCsObjectLatestLogEntryDateTime = "$($adCsObjectLatestLogEntry.TimeStamp) UTC"


    $resultString =
    "Password Hash Synchronization agent read the last password change for the specified object at: $adCsObjectLatestLogEntryDateTime `n"  +
    "The result of the Password Hash Synchronization attempt was: `n"
    ReportOutput -PropertyName 'Last password change for the specified object at' -PropertyValue "$adCsObjectLatestLogEntryDateTime"


    if (-not $isNonInteractiveMode)
    {
        Write-Host $resultString
        $resultString = ""
    }

    if ($adCsObjectLatestLogEntry.Status -eq "Success")
    {
        WriteEventLog($EventIdSingleObjectSuccess)($EventMsgSingleObjectSuccess -f ($adConnectorName, $dn, $adCsObjectLatestLogEntryDateTime))

        $resultString + "Password hash is synchronized successfully" | ReportOutput 
        ReportOutput -PropertyName 'Last password change status for the specified object' -PropertyValue "Succeeded"
    }
    elseif ($adCsObjectLatestLogEntry.Status -eq "FilteredByTarget")
    {
        WriteEventLog($EventIdSingleObjectFilteredByTarget)($EventMsgSingleObjectFilteredByTarget -f ($adConnectorName, $dn, $adCsObjectLatestLogEntryDateTime))

        $resultString + 
        "Password is set with user must change password at next logon option. Temporary passwords are not supposed to be synchronized. `n" +
        "Please see: https://go.microsoft.com/fwlink/?linkid=847233" | ReportError

    }
    elseif ($adCsObjectLatestLogEntry.Status -eq "TargetNotExportedToDirectory")
    {
        WriteEventLog($EventIdSingleObjectNotExported)($EventMsgSingleObjectNotExported -f ($adConnectorName, $dn, $adCsObjectLatestLogEntryDateTime))

        $resultString + "The object in the AAD connector space has not yet been exported. The password hash is not supposed to be synchronized." | ReportError

        # Check if target AAD connector space object has export error
        if ($aadCsObject.HasExportError -eq $true)
        {
            "The target AAD connector space object has export error" | ReportError
        }

        "Please see: https://go.microsoft.com/fwlink/?linkid=847233" | Write-Host -fore Red
    }
    elseif ($adCsObjectLatestLogEntry.Status -eq "NoTargetConnection")
    {
        WriteEventLog($EventIdSingleObjectNoTargetConnection)($EventMsgSingleObjectNoTargetConnection -f ($adConnectorName, $dn, $adCsObjectLatestLogEntryDateTime))
        
        $resultString + "The object is not synced to the AAD connector space or Password Hash Synchronization rule(s) are not available" | ReportError
        "Please see: https://go.microsoft.com/fwlink/?linkid=847233" | Write-Host -fore Red
    }
    else
    {
        WriteEventLog($EventIdSingleObjectOtherFailure)($EventMsgSingleObjectOtherFailure -f ($adConnectorName, $dn, $adCsObjectLatestLogEntryDateTime, $adCsObjectLatestLogEntry.Status))

        $resultString + "$($adCsObjectLatestLogEntry.Status)" | ReportError
    }

    Write-Host "`r`n"
}

Function PromptPasswordSyncSingleObjectDiagnostics
{
    #
    # Prompt user to diagnose single object issues
    #
    do
    {
        $confirmation = Read-Host "Would you like to diagnose single object issues? [y/n]"

        if (($confirmation -eq 'n') -or ($confirmation -eq 'N'))
        {
            return
        }
    } while(($confirmation -ne 'y') -or ($confirmation -ne 'Y'))
    
    #
    # Diagnose password hash synchronization single object issues 
    #
    DiagnosePasswordSyncSingleObject
}

Function SynchronizeSingleObjectPassword
{
    Write-Host "`r`n"

    Write-Host "==========================================================================="
    Write-Host "=                                                                         ="
    Write-Host "=           Single Object Password Hash Synchronization Utility           ="
    Write-Host "=                                                                         ="
    Write-Host "==========================================================================="

    Write-Host "`r`n"

    "This utility will attempt to synchronize the current password hash stored in the on-premises Active Directory for the specified user account." | Write-Host -fore Cyan

    # Check if Staging Mode is enabled
    $isStagingModeEnabled = IsStagingModeEnabled
    if ($isStagingModeEnabled -eq $true)
    {
        Write-Host "`r`n"
        "Staging mode is enabled. Password Hash Synchronization does not work when staging mode is enabled." | Write-Host -fore Red
        return
    }

    # Get AD Connectors
    $adConnectors = GetADConnectors
    if ($adConnectors -eq $null)
    {
        Write-Host "`r`n"
        "No AD Connector is found. Password Hash Synchronization does not work in the absence of AD Connectors." | Write-Host -fore Red
        return
    }

    # Get AAD Connector
    $aadConnector = GetAADConnector
    if ($aadConnector -eq $null)
    {
        Write-Host "`r`n"
        "No AAD Connector is found. Password Hash Synchronization does not work in the absence of AAD Connector." | Write-Host -fore Red
        return
    }

    "Please specify the user account by providing the regarding AD Connector Name and DistinguishedName." | Write-Host -fore Cyan

    #
    # Get AD Connector Name as input
    # Prompt user again and provide a list of AD Connectors in case of wrong input
    #
    $adConnectorName = $null
    $adConnector = $null

    while ($true)
    {
        while ([string]::IsNullOrEmpty($adConnectorName))
        {
            Write-Host "`r`n"

            Write-Host "List of AD Connectors:"
            Write-Host "----------------------"

            foreach ($adConnector in $adConnectors)
            {
                Write-Host $adConnector.Name                
            }

            if ($adConnectors.length -eq 1)
            {
                $adConnectorName = $adConnectors[0].Name
            }
            else
            {
                Write-Host "`r`n"

                $adConnectorName = Read-Host "Please enter AD Connector Name"
            }
        }
        
        $adConnector = GetADConnectorByName($adConnectorName)

        if ($adConnector -eq $null)
        {
            Write-Warning "There is no AD Connector with name `"$adConnectorName`". Please try again!"

            $adConnectorName = [string]::Empty
        }
        else
        {
            break
        }
    }

    # Get password hash sync configuration for the specified AD Connector
    $adConnectorPasswordSyncConfig = GetADConnectorPasswordSyncConfiguration($adConnector)

    # Check if password hash sync is enabled for the AD connector.
    if ($adConnectorPasswordSyncConfig.Enabled -eq $true)
    {
        "Password Hash Synchronization is enabled for AD Connector - $adConnectorName" | Write-Host -fore Green
    }
    else
    {
        "Password Hash Synchronization is disabled for AD Connector - $adConnectorName" | Write-Host -fore Red
        "Please enable Password Hash Synchronization from AADConnect Wizard in order to synchronize passwords" | Write-Host -fore Red
        return
    }

    Write-Host "`r`n"
    $dn = $null
    $adCsObject = $null

    while ($true)
    {
        while ([string]::IsNullOrEmpty($dn))
        {
            # Get AD connector space object Distinguished Name as input
            $dn = Read-Host "Please enter AD connector space object Distinguished Name"
        }
        
        #
        # Check if the object with the given Distinguished Name is in the AD connector space
        #
        $adCsObject = GetCSObject($adConnectorName)($dn)
    
        if ($adCsObject -eq $null)
        {
            "The object is not found in the AD connector space - $ADConnectorName" | Write-Host -fore Red
            Write-Host "`r`n"

            $dn = [string]::Empty

            do
            {
                $confirmation = Read-Host "Would you like to try another Distinguished Name? [y/n]"

                if (($confirmation -eq 'n') -or ($confirmation -eq 'N'))
                {
                    Write-Host "`r`n"
                    return
                }
            } while(($confirmation -ne 'y') -and ($confirmation -ne 'Y'))

            Write-Host "`r`n"
        }
        else
        {
            break
        }
    }

    if ($adCsObject.ObjectType -ne "user")
    {
        "Connector space object type is $($adCsObject.ObjectType). Password Hash Synchronization is only supported for the object type user in Active Directory." | Write-Host -fore Red
        return
    }

    $singleObjectPasswordSyncResult = Invoke-ADSyncCSObjectPasswordHashSync -CsObject $adCsObject
    
    if ($singleObjectPasswordSyncResult.Contains("success"))
    {
        $singleObjectPasswordSyncResult | Write-Host -fore Green
    }
    else
    {
        $singleObjectPasswordSyncResult | Write-Host -fore Red
    }
}

Function DiagnosePasswordHashSyncNonInteractiveMode
{
    param
    (
        [string]
        [parameter(mandatory=$true)]
        $ADConnectorName
    )

    $timezone = [TimeZoneInfo]::Local
    ReportOutput -PropertyName 'Sync Server TimeZone' -PropertyValue $timezone.DisplayName

    DiagnosePasswordHashSyncHelper -ADConnectorName $ADConnectorName
}

Function DiagnosePasswordHashSync
{
    DiagnosePasswordHashSyncHelper

    Write-Host "`r`n"

    do
    {
        $answer = Read-Host "Did you find Password Hash Sync General Diagnostics helpful? [y/n]"
    } 
    while(($answer -ne 'y') -and ($answer -ne 'Y') -and ($answer -ne 'n') -and ($answer -ne 'N'))

    WriteEventLog($EventIdIsPwdSyncGeneralDiagnosticsHelpful)($EventMsgIsPwdSyncGeneralDiagnosticsHelpful -f $answer)
}

#
# Diagnose Password Hash Sync - composed of 3 parts
# 
#    + Password hash sync configurations
#    + Connectivity to each AD Forest
#    + Single Object Issues
#
# This function is the point of entry for diagnosing password hash sync issues
#
Function DiagnosePasswordHashSyncHelper
{
    param
    (
        [string]
        [parameter(mandatory=$false)]
        $ADConnectorName = [string]::Empty
    )

    WriteEventLog($EventIdPwdSyncTroubleshootingRun)($EventMsgPwdSyncTroubleshootingRun)

    # Check if Staging Mode is enabled
    $isStagingModeEnabled = IsStagingModeEnabled
    if ($isStagingModeEnabled -eq $true)
    {
        WriteEventLog($EventIdStagingModeEnabled)($EventMsgStagingModeEnabled)

        "Staging mode is enabled. Password Hash Synchronization does not work when staging mode is enabled." | ReportError
        return
    }

    # Get AD Connectors

    if (-not [string]::IsNullOrEmpty($ADConnectorName))
    {
        $adConnectors = GetADConnectorByName -ADConnectorName $ADConnectorName
    }
    else
    {
        $adConnectors = GetADConnectors
    }

    if ($adConnectors -eq $null)
    {
        "No AD Connector is found. Password Hash Synchronization does not work in the absence of AD Connectors." | ReportError
        return
    }

    # Get AAD Connector
    $aadConnector = GetAADConnector
    if ($aadConnector -eq $null)
    {
        "No AAD Connector is found. Password Hash Synchronization does not work in the absence of AAD Connector." | ReportError
        return
    }

    # AAD Tenant Name
    $aadTenantName = GetAADTenantName($aadConnector)

    Write-Host "`r`n"

    Write-Host "========================================================================"
    Write-Host "=                                                                      ="
    Write-Host "=            Password Hash Synchronization General Diagnostics         ="
    Write-Host "=                                                                      ="
    Write-Host "========================================================================"

    Write-Host "`r`n"

    Write-Host "AAD Tenant - $aadTenantName"

    if (-not $isNonInteractiveMode)
    {
        # Password Hash Sync Cloud Configuration
        $passwordHashSyncCloudConfiguration = GetPasswordHashSyncCloudConfiguration($aadConnector)
        if ($passwordHashSyncCloudConfiguration -eq $true)
        {
            "Password Hash Synchronization cloud configuration is enabled" | ReportOutput
        }
        else
        {
            "Password Hash Synchronization cloud configuration is disabled" | ReportError
        }
    }


    Write-Host "`r`n"

    #
    # Password Hash Sync Local Configuration
    #
    # Enabled  - there is one or more AD Connectors enabled for password hash sync
    # Disabled - all AD Connectors are disabled for password hash sync
    #
    $passwordHashSyncLocalConfiguration = $false

    # Check Password Hash Sync AWS API Call Failures 
    CheckLatestPasswordSyncAWSCallFailureEvents

    Write-Host "`r`n"

    #
    # Check if password hash sync agent continuously fails to compute MD5 decryption key.
    #
    IsPersistentMD5Failure

    #
    # Check if verbose logging for password hash sync is turned on
    #
    CheckVerboseLoggingForPHS

    #
    # Per AD Connector Password Hash Sync Status
    # 
    foreach ($adConnector in $adConnectors)
    {
        # AD Connector password hash sync configuration
        $adConnectorPasswordSyncConfig = GetADConnectorPasswordSyncConfiguration($adConnector)
        
        # AD Connector latest heartbeat (ping) event in the last 3 hours
        $adConnectorLatestPingEvent = GetADConnectorLatestPingEvent($adConnector)

        Write-Host "`r`n"
        Write-Host "AD Connector - $($adConnector.Name)"

        if ($adConnectorPasswordSyncConfig.Enabled -eq $true)
        {
            "Password Hash Synchronization is enabled" | ReportOutput 

            if ($adConnectorLatestPingEvent -eq $null)
            {
                WriteEventLog($EventIdConnectorNoHeartBeat)($EventMsgConnectorNoHeartBeat -f ($adConnector.Name))

                #
                # Check if password hash sync agent continuously gets health task failures
                #
                # AWS is pinged through password hash sync health task. The failures in this category are the ones 
                # prior to making an AWS API call for the ping.
                #
                IsPersistentHealthTaskFailure($adConnector)

                # AD Connector latest password hash sync activity event in the last 2 hours
                $adConnectorPasswordHashSyncLatestActivityEvent = GetADConnectorPasswordHashSyncLatestActivityEvent($adConnector)

                #
                # Password Hash Synchronization events 609, 610 and 615 are about stopping the password hash sync channel for the AD Connector.
                #
                # 609 and 610 indicates that there is an intentional attempt to stop the channel. When the channel is stopped intentionally,
                # AD Connector configuration is modified as password hash sync disabled. Therefore, it is NOT very likely to see these events 
                # here as there is already a check for the AD Connector password hash sync configuration above.
                #
                # 615 indicates that the channel stopped due to an exception.
                #
                if ($adConnectorPasswordHashSyncLatestActivityEvent -eq $null -or 
                    $adConnectorPasswordHashSyncLatestActivityEvent.InstanceId -eq 609 -or
                    $adConnectorPasswordHashSyncLatestActivityEvent.InstanceId -eq 610 -or
                    $adConnectorPasswordHashSyncLatestActivityEvent.InstanceId -eq 615)
                {
                    WriteEventLog($EventIdConnectorPwdSyncStopped)($EventMsgConnectorPwdSyncStopped -f ($adConnector.Name))

                    "Password Hash Synchronization is NOT running for AD Connector: $($adConnector.Name)" | ReportError
                    Write-Host "`r`n"

                    if (-not $isNonInteractiveMode)
                    {
                        do
                        {
                            $confirmation = Read-Host "Would you like to RESTART password hash synchronization for AD Connector: $($adConnector.Name)? [y/n]"

                            if (($confirmation -eq 'y') -or ($confirmation -eq 'Y'))
                            {
                                Write-Host "Restarting..."
                                RestartADConnectorPasswordHashSyncChannel($adConnector)($aadConnector)

                                Write-Host "`r`n"
                                break
                            }
                        } while(($confirmation -ne 'n') -or ($confirmation -ne 'N'))
                    }
                }
                else
                {
                    WriteEventLog($EventIdPwdSyncActivityWithoutHeartbeat)($EventMsgPwdSyncActivityWithoutHeartbeat -f ($adConnector.Name))
                }
            }
            else
            {
                $adConnectorLatestPingDateTime = GetDateTimeLocaleEnUs($adConnectorLatestPingEvent.TimeGenerated)
                "Latest Password Hash Synchronization heartbeat is detected at: $adConnectorLatestPingDateTime UTC" | 
                ReportOutput -PropertyName 'Latest PHS heartbeat detected at' -PropertyValue "$adConnectorLatestPingDateTime UTC"
                
            }
        }
        else
        {
            "Password Hash Synchronization is disabled" | ReportError
            continue
            Write-Host "`r`n"
        }

        $passwordHashSyncLocalConfiguration = $passwordHashSyncLocalConfiguration -or $adConnectorPasswordSyncConfig.Enabled

        # Diagnose connectivity for each AD forest
        DiagnoseADConnectivity($adConnector)
    }

    # Check if password hash sync local and cloud configurations are same. Skip comparing configuration in Non-Interactive mode. Since ASC already has config values.
    if ((-not $isNonInteractiveMode) -and ($passwordHashSyncLocalConfiguration -ne $passwordHashSyncCloudConfiguration))
    {
        WriteEventLog($EventIdPwdSyncLocalAndCloudConfigDifferent)($EventMsgPwdSyncLocalAndCloudConfigDifferent -f ($passwordHashSyncLocalConfiguration, $passwordHashSyncCloudConfiguration))

        if ($passwordHashSyncLocalConfiguration -eq $true -and $passwordHashSyncCloudConfiguration -eq $false)
        {
            WriteEventLog($EventIdPwdSyncLocalEnabledAndCloudDisabled)($EventMsgPwdSyncLocalAndCloudConfigDifferent -f ($passwordHashSyncLocalConfiguration, $passwordHashSyncCloudConfiguration))
        }
        elseif ($passwordHashSyncLocalConfiguration -eq $false -and $passwordHashSyncCloudConfiguration -eq $true)
        {
            WriteEventLog($EventIdPwdSyncLocalDisabledAndCloudEnabled)($EventMsgPwdSyncLocalAndCloudConfigDifferent -f ($passwordHashSyncLocalConfiguration, $passwordHashSyncCloudConfiguration))
        }
        elseif ($passwordHashSyncCloudConfiguration -eq $null)
        {
            WriteEventLog($EventIdPwdSyncCloudConfigNull)($EventMsgPwdSyncLocalAndCloudConfigDifferent -f ($passwordHashSyncLocalConfiguration, $passwordHashSyncCloudConfiguration))
        }

        Write-Host "`r`n"
        "Password Hash Synchronization local and cloud configurations are different" | ReportError
        return
    }
    elseif ($passwordHashSyncLocalConfiguration -eq $false)
    {
        WriteEventLog($EventIdPwdSyncLocalConfigDisabled)($EventMsgPwdSyncLocalConfigDisabled)

        Write-Host "`r`n"
        ReportWarning "Password Hash Synchronization is disabled for all AD Connectors"
        ReportWarning "In order to synchronize passwords, you need to enable Password Hash Synchronization from AADConnect Wizard"
        return
    }

    Write-Host "`r`n"
}
# SIG # Begin signature block
# MIIoOQYJKoZIhvcNAQcCoIIoKjCCKCYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCPmlO0w0yrXsnN
# UvBYy1C7D0dCdwWjqZVKb/1e1lJfzqCCDYIwggYAMIID6KADAgECAhMzAAADXJXz
# SFtKBGrPAAAAAANcMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjMwNDA2MTgyOTIyWhcNMjQwNDAyMTgyOTIyWjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDijA1UCC84R0x+9Vr/vQhPNbfvIOBFfymE+kuP+nho3ixnjyv6vdnUpgmm6RT/
# pL9cXL27zmgVMw7ivmLjR5dIm6qlovdrc5QRrkewnuQHnvhVnLm+pLyIiWp6Tow3
# ZrkoiVdip47m+pOBYlw/vrkb8Pju4XdA48U8okWmqTId2CbZTd8yZbwdHb8lPviE
# NMKzQ2bAjytWVEp3y74xc8E4P6hdBRynKGF6vvS6sGB9tBrvu4n9mn7M99rp//7k
# ku5t/q3bbMjg/6L6mDePok6Ipb22+9Fzpq5sy+CkJmvCNGPo9U8fA152JPrt14uJ
# ffVvbY5i9jrGQTfV+UAQ8ncPAgMBAAGjggF/MIIBezArBgNVHSUEJDAiBgorBgEE
# AYI3TBMBBgorBgEEAYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUXgIsrR+tkOQ8
# 10ekOnvvfQDgTHAwRQYDVR0RBD4wPKQ6MDgxHjAcBgNVBAsTFU1pY3Jvc29mdCBD
# b3Jwb3JhdGlvbjEWMBQGA1UEBRMNMjMzMTEwKzUwMDg2ODAfBgNVHSMEGDAWgBRI
# bmTlUAXTgqoXNzcitW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIwMTEt
# MDctMDguY3JsMGEGCCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDExXzIw
# MTEtMDctMDguY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIBABIm
# T2UTYlls5t6i5kWaqI7sEfIKgNquF8Ex9yMEz+QMmc2FjaIF/HQQdpJZaEtDM1Xm
# 07VD4JvNJEplZ91A4SIxjHzqgLegfkyc384P7Nn+SJL3XK2FK+VAFxdvZNXcrkt2
# WoAtKo0PclJOmHheHImWSqfCxRispYkKT9w7J/84fidQxSj83NPqoCfUmcy3bWKY
# jRZ6PPDXlXERRvl825dXOfmCKGYJXHKyOEcU8/6djs7TDyK0eH9ss4G9mjPnVZzq
# Gi/qxxtbddZtkREDd0Acdj947/BTwsYLuQPz7SNNUAmlZOvWALPU7OOVQlEZzO8u
# Ec+QH24nep/yhKvFYp4sHtxUKm1ZPV4xdArhzxJGo48Be74kxL7q2AlTyValLV98
# u3FY07rNo4Xg9PMHC6sEAb0tSplojOHFtGtNb0r+sioSttvd8IyaMSfCPwhUxp+B
# Td0exzQ1KnRSBOZpxZ8h0HmOlMJOInwFqrCvn5IjrSdjxKa/PzOTFPIYAfMZ4hJn
# uKu15EUuv/f0Tmgrlfw+cC0HCz/5WnpWiFso2IPHZyfdbbOXO2EZ9gzB1wmNkbBz
# hj8hFyImnycY+94Eo2GLavVTtgBiCcG1ILyQabKDbL7Vh/OearAxcRAmcuVAha07
# WiQx2aLghOSaZzKFOx44LmwUxRuaJ4vO/PRZ7EzAMIIHejCCBWKgAwIBAgIKYQ6Q
# 0gAAAAAAAzANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgT
# Cldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
# dCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNh
# dGUgQXV0aG9yaXR5IDIwMTEwHhcNMTEwNzA4MjA1OTA5WhcNMjYwNzA4MjEwOTA5
# WjB+MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYDVQQD
# Ex9NaWNyb3NvZnQgQ29kZSBTaWduaW5nIFBDQSAyMDExMIICIjANBgkqhkiG9w0B
# AQEFAAOCAg8AMIICCgKCAgEAq/D6chAcLq3YbqqCEE00uvK2WCGfQhsqa+laUKq4
# BjgaBEm6f8MMHt03a8YS2AvwOMKZBrDIOdUBFDFC04kNeWSHfpRgJGyvnkmc6Whe
# 0t+bU7IKLMOv2akrrnoJr9eWWcpgGgXpZnboMlImEi/nqwhQz7NEt13YxC4Ddato
# 88tt8zpcoRb0RrrgOGSsbmQ1eKagYw8t00CT+OPeBw3VXHmlSSnnDb6gE3e+lD3v
# ++MrWhAfTVYoonpy4BI6t0le2O3tQ5GD2Xuye4Yb2T6xjF3oiU+EGvKhL1nkkDst
# rjNYxbc+/jLTswM9sbKvkjh+0p2ALPVOVpEhNSXDOW5kf1O6nA+tGSOEy/S6A4aN
# 91/w0FK/jJSHvMAhdCVfGCi2zCcoOCWYOUo2z3yxkq4cI6epZuxhH2rhKEmdX4ji
# JV3TIUs+UsS1Vz8kA/DRelsv1SPjcF0PUUZ3s/gA4bysAoJf28AVs70b1FVL5zmh
# D+kjSbwYuER8ReTBw3J64HLnJN+/RpnF78IcV9uDjexNSTCnq47f7Fufr/zdsGbi
# wZeBe+3W7UvnSSmnEyimp31ngOaKYnhfsi+E11ecXL93KCjx7W3DKI8sj0A3T8Hh
# hUSJxAlMxdSlQy90lfdu+HggWCwTXWCVmj5PM4TasIgX3p5O9JawvEagbJjS4NaI
# jAsCAwEAAaOCAe0wggHpMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBRIbmTl
# UAXTgqoXNzcitW2oynUClTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNV
# HQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBRyLToCMZBDuRQF
# TuHqp8cx0SOJNDBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLm1pY3Jvc29m
# dC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFfMDNf
# MjIuY3JsMF4GCCsGAQUFBwEBBFIwUDBOBggrBgEFBQcwAoZCaHR0cDovL3d3dy5t
# aWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFfMDNf
# MjIuY3J0MIGfBgNVHSAEgZcwgZQwgZEGCSsGAQQBgjcuAzCBgzA/BggrBgEFBQcC
# ARYzaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9kb2NzL3ByaW1hcnlj
# cHMuaHRtMEAGCCsGAQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAHAAbwBsAGkAYwB5
# AF8AcwB0AGEAdABlAG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQBn8oal
# mOBUeRou09h0ZyKbC5YR4WOSmUKWfdJ5DJDBZV8uLD74w3LRbYP+vj/oCso7v0ep
# o/Np22O/IjWll11lhJB9i0ZQVdgMknzSGksc8zxCi1LQsP1r4z4HLimb5j0bpdS1
# HXeUOeLpZMlEPXh6I/MTfaaQdION9MsmAkYqwooQu6SpBQyb7Wj6aC6VoCo/KmtY
# SWMfCWluWpiW5IP0wI/zRive/DvQvTXvbiWu5a8n7dDd8w6vmSiXmE0OPQvyCInW
# H8MyGOLwxS3OW560STkKxgrCxq2u5bLZ2xWIUUVYODJxJxp/sfQn+N4sOiBpmLJZ
# iWhub6e3dMNABQamASooPoI/E01mC8CzTfXhj38cbxV9Rad25UAqZaPDXVJihsMd
# YzaXht/a8/jyFqGaJ+HNpZfQ7l1jQeNbB5yHPgZ3BtEGsXUfFL5hYbXw3MYbBL7f
# QccOKO7eZS/sl/ahXJbYANahRr1Z85elCUtIEJmAH9AAKcWxm6U/RXceNcbSoqKf
# enoi+kiVH6v7RyOA9Z74v2u3S5fi63V4GuzqN5l5GEv/1rMjaHXmr/r8i+sLgOpp
# O6/8MO0ETI7f33VtY5E90Z1WTk+/gFcioXgRMiF670EKsT/7qMykXcGhiJtXcVZO
# SEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCGg0wghoJAgEBMIGVMH4xCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jv
# c29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAANclfNIW0oEas8AAAAAA1ww
# DQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYK
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIJOT5BQ9
# XdLBvSsKgM11CqOQqP/pr+V5nDPYxjuX7gsVMEIGCisGAQQBgjcCAQwxNDAyoBSA
# EgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20w
# DQYJKoZIhvcNAQEBBQAEggEA4Jw2Ln9X6pvUZ/+z3WIjt6B6oJRPuvnesXv7rlXh
# 9jkawE/Do4G4S71STYfHT/O4EkJ/EJxyA+A60Dtj4oOGEvbh/HvCIGH/6WWk2dRq
# 4/9gUaib8MOQ7qkbs3qW2j1q2tautzV078F/FejUVY4FkHh2kJ6/a6BuKwknOWCF
# RO9XcLhfL1JPKj9w5Ll1LTzucNSRs9ZcEQXIV6FtJ0P38mQ98TKmFJ7Ova0EaXAl
# aq5/9mHsLfUnAeHF6EOmu6xHwbldIVvAKbP+3YuIILYr8/TcB/8m7szV+ODeyt5U
# 9FWAZwlIvN15Fo6K/2xAaeF2EK+yzIlq8WYtuCD3wKMcB6GCF5cwgheTBgorBgEE
# AYI3AwMBMYIXgzCCF38GCSqGSIb3DQEHAqCCF3AwghdsAgEDMQ8wDQYJYIZIAWUD
# BAIBBQAwggFSBgsqhkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGEWQoD
# ATAxMA0GCWCGSAFlAwQCAQUABCBepW6FOqRkMCDcx/zIY7n3VZNoF1UCs5VKT/iR
# GQKf6wIGZQPlPsyxGBMyMDIzMTAwNDE5MjgyMS44NTRaMASAAgH0oIHRpIHOMIHL
# MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVk
# bW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxN
# aWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRT
# UyBFU046OTIwMC0wNUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0
# YW1wIFNlcnZpY2WgghHtMIIHIDCCBQigAwIBAgITMwAAAc9SNr5xS81IygABAAAB
# zzANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGlu
# Z3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
# cmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDAe
# Fw0yMzA1MjUxOTEyMTFaFw0yNDAyMDExOTEyMTFaMIHLMQswCQYDVQQGEwJVUzET
# MBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMV
# TWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1lcmlj
# YSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046OTIwMC0wNUUw
# LUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2UwggIi
# MA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC4Pct+15TYyrUje553lzBQodgm
# d5Bz7WuH8SdHpAoWz+01TrHExBSuaMKnxvVMsyYtas5h6aopUGAS5WKVLZAvUtH6
# 2TKmAE0JK+i1hafiCSXLZPcRexxeRkOqeZefLBzXp0nudMOXUUab333Ss8LkoK4l
# 3LYxm1Ebsr3b2OTo2ebsAoNJ4kSxmVuPM7C+RDhGtVKR/EmHsQ9GcwGmluu54bqi
# VFd0oAFBbw4txTU1mruIGWP/i+sgiNqvdV/wah/QcrKiGlpWiOr9a5aGrJaPSQD2
# xgEDdPbrSflYxsRMdZCJI8vzvOv6BluPcPPGGVLEaU7OszdYjK5f4Z5Su/lPK1eS
# T5PC4RFsVcOiS4L0sI4IFZywIdDJHoKgdqWRp6Q5vEDk8kvZz6HWFnYLOlHuqMEY
# vQLr6OgooYU9z0A5cMLHEIHYV1xiaBzx2ERiRY9MUPWohh+TpZWEUZlUm/q9anXV
# RN0ujejm6OsUVFDssIMszRNCqEotJGwtHHm5xrCKuJkFr8GfwNelFl+XDoHXrQYL
# 9zY7Np+frsTXQpKRNnmI1ashcn5EC+wxUt/EZIskWzewEft0/+/0g3+8YtMkUdaQ
# E5+8e7C8UMiXOHkMK25jNNQqLCedlJwFIf9ir9SpMc72NR+1j6Uebiz/ZPV74do3
# jdVvq7DiPFlTb92UKwIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFDaeKPtp0eTSVdG+
# gZc5BDkabTg4MB8GA1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8GA1Ud
# HwRYMFYwVKBSoFCGTmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY3Js
# L01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBsBggr
# BgEFBQcBAQRgMF4wXAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0LmNv
# bS9wa2lvcHMvY2VydHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUyMDIw
# MTAoMSkuY3J0MAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgw
# DgYDVR0PAQH/BAQDAgeAMA0GCSqGSIb3DQEBCwUAA4ICAQBQgm4pnA0xkd/9uKXJ
# MzdMYyxUfUm/ZusUBa32MEZXQuMGp20pSuX2VW9/tpTMo5bkaJdBVoUyd2DbDsNb
# 1kjr/36ntT0jvL3AoWStAFhZBypmpPbx+BPK49ZlejlM4d5epX668tRRGfFip9Ti
# l9yKRfXBrXnM/q64IinN7zXEQ3FFQhdJMzt8ibXClO7eFA+1HiwZPWysYWPb/ZOF
# obPEMvXie+GmEbTKbhE5tze6RrA9aejjP+v1ouFoD5bMj5Qg+wfZXqe+hfYKpMd8
# QOnQyez+Nlj1itynOZWfwHVR7dVwV0yLSlPT+yHIO8g+3fWiAwpoO17bDcntSZ7Y
# OBljXrIgad4W4gX+4tp1eBsc6XWIITPBNzxQDZZRxD4rXzOB6XRlEVJdYZQ8gbXO
# irg/dNvS2GxcR50QdOXDAumdEHaGNHb6y2InJadCPp2iT5QLC4MnzR+YZno1b8mW
# pCdOdRs9g21QbbrI06iLk9KD61nx7K5ReSucuS5Z9nbkIBaLUxDesFhr1wmd1ynf
# 0HQ51Swryh7YI7TXT0jr81mbvvI9xtoqjFvIhNBsICdCfTR91ylJTH8WtUlpDhEg
# SqWt3gzNLPTSvXAxXTpIM583sZdd+/2YGADMeWmt8PuMce6GsIcLCOF2NiYZ10SX
# HZS5HRrLrChuzedDRisWpIu5uTCCB3EwggVZoAMCAQICEzMAAAAVxedrngKbSZkA
# AAAAABUwDQYJKoZIhvcNAQELBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpX
# YXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQg
# Q29ycG9yYXRpb24xMjAwBgNVBAMTKU1pY3Jvc29mdCBSb290IENlcnRpZmljYXRl
# IEF1dGhvcml0eSAyMDEwMB4XDTIxMDkzMDE4MjIyNVoXDTMwMDkzMDE4MzIyNVow
# fDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1Jl
# ZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMd
# TWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwggIiMA0GCSqGSIb3DQEBAQUA
# A4ICDwAwggIKAoICAQDk4aZM57RyIQt5osvXJHm9DtWC0/3unAcH0qlsTnXIyjVX
# 9gF/bErg4r25PhdgM/9cT8dm95VTcVrifkpa/rg2Z4VGIwy1jRPPdzLAEBjoYH1q
# UoNEt6aORmsHFPPFdvWGUNzBRMhxXFExN6AKOG6N7dcP2CZTfDlhAnrEqv1yaa8d
# q6z2Nr41JmTamDu6GnszrYBbfowQHJ1S/rboYiXcag/PXfT+jlPP1uyFVk3v3byN
# pOORj7I5LFGc6XBpDco2LXCOMcg1KL3jtIckw+DJj361VI/c+gVVmG1oO5pGve2k
# rnopN6zL64NF50ZuyjLVwIYwXE8s4mKyzbnijYjklqwBSru+cakXW2dg3viSkR4d
# Pf0gz3N9QZpGdc3EXzTdEonW/aUgfX782Z5F37ZyL9t9X4C626p+Nuw2TPYrbqgS
# Uei/BQOj0XOmTTd0lBw0gg/wEPK3Rxjtp+iZfD9M269ewvPV2HM9Q07BMzlMjgK8
# QmguEOqEUUbi0b1qGFphAXPKZ6Je1yh2AuIzGHLXpyDwwvoSCtdjbwzJNmSLW6Cm
# gyFdXzB0kZSU2LlQ+QuJYfM2BjUYhEfb3BvR/bLUHMVr9lxSUV0S2yW6r1AFemzF
# ER1y7435UsSFF5PAPBXbGjfHCBUYP3irRbb1Hode2o+eFnJpxq57t7c+auIurQID
# AQABo4IB3TCCAdkwEgYJKwYBBAGCNxUBBAUCAwEAATAjBgkrBgEEAYI3FQIEFgQU
# KqdS/mTEmr6CkTxGNSnPEP8vBO4wHQYDVR0OBBYEFJ+nFV0AXmJdg/Tl0mWnG1M1
# GelyMFwGA1UdIARVMFMwUQYMKwYBBAGCN0yDfQEBMEEwPwYIKwYBBQUHAgEWM2h0
# dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvRG9jcy9SZXBvc2l0b3J5Lmh0
# bTATBgNVHSUEDDAKBggrBgEFBQcDCDAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMA
# QTALBgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBTV9lbL
# j+iiXGJo0T2UkFvXzpoYxDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3JsLm1p
# Y3Jvc29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXRfMjAxMC0w
# Ni0yMy5jcmwwWgYIKwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIz
# LmNydDANBgkqhkiG9w0BAQsFAAOCAgEAnVV9/Cqt4SwfZwExJFvhnnJL/Klv6lwU
# tj5OR2R4sQaTlz0xM7U518JxNj/aZGx80HU5bbsPMeTCj/ts0aGUGCLu6WZnOlNN
# 3Zi6th542DYunKmCVgADsAW+iehp4LoJ7nvfam++Kctu2D9IdQHZGN5tggz1bSNU
# 5HhTdSRXud2f8449xvNo32X2pFaq95W2KFUn0CS9QKC/GbYSEhFdPSfgQJY4rPf5
# KYnDvBewVIVCs/wMnosZiefwC2qBwoEZQhlSdYo2wh3DYXMuLGt7bj8sCXgU6ZGy
# qVvfSaN0DLzskYDSPeZKPmY7T7uG+jIa2Zb0j/aRAfbOxnT99kxybxCrdTDFNLB6
# 2FD+CljdQDzHVG2dY3RILLFORy3BFARxv2T5JL5zbcqOCb2zAVdJVGTZc9d/HltE
# AY5aGZFrDZ+kKNxnGSgkujhLmm77IVRrakURR6nxt67I6IleT53S0Ex2tVdUCbFp
# AUR+fKFhbHP+CrvsQWY9af3LwUFJfn6Tvsv4O+S3Fb+0zj6lMVGEvL8CwYKiexcd
# FYmNcP7ntdAoGokLjzbaukz5m/8K6TT4JDVnK+ANuOaMmdbhIurwJ0I9JZTmdHRb
# atGePu1+oDEzfbzL6Xu/OHBE0ZDxyKs6ijoIYn/ZcGNTTY3ugm2lBRDBcQZqELQd
# VTNYs6FwZvKhggNQMIICOAIBATCB+aGB0aSBzjCByzELMAkGA1UEBhMCVVMxEzAR
# BgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1p
# Y3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJpY2Eg
# T3BlcmF0aW9uczEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjkyMDAtMDVFMC1E
# OTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMKAQEw
# BwYFKw4DAhoDFQDq8xzVXwLguauAQj1rrJ4/TyEMm6CBgzCBgKR+MHwxCzAJBgNV
# BAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4w
# HAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29m
# dCBUaW1lLVN0YW1wIFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA6MgX0TAiGA8y
# MDIzMTAwNDE2NTY0OVoYDzIwMjMxMDA1MTY1NjQ5WjB3MD0GCisGAQQBhFkKBAEx
# LzAtMAoCBQDoyBfRAgEAMAoCAQACAgVHAgH/MAcCAQACAhM6MAoCBQDoyWlRAgEA
# MDYGCisGAQQBhFkKBAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMHoSChCjAI
# AgEAAgMBhqAwDQYJKoZIhvcNAQELBQADggEBAD4tytM925HVicViyiOBstAs+J7c
# JGiEbgaSUqSiBfOCPAKBoaVqLWDsabfim4c3cukezhJfDo81Oo3m4LeeTntsB0DH
# ubwkIWjW7ljQLICSkOKrkWiDrGQIXzgZStMdgRm2WCJPD6QAvdxiMHifld/BlQX2
# 43oCRFloqPgYnqGZ+6GHEzsl1pE+nsiC7Up32eb9WVtAxqSusc3Y9+3OZuZ5pxbQ
# ubEWm8nmNZEqvvNPZz2chQrB2+FWtilDkIIgDGXUm9JsBexYjgHWwC7b9jPekAN1
# NALxuKB83hU3vPJbssGSz8pvpAbpDW6Kqj1mcw9KVwfPWf2UrC7nWcH7ZCoxggQN
# MIIECQIBATCBkzB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQ
# MA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9u
# MSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAc9S
# Nr5xS81IygABAAABzzANBglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkDMQ0G
# CyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJBDEiBCBTv4lj/Piqk2Rij6XFACdKsS88
# k1P4UmK4SkkaVUbShzCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EILPpsLqe
# NS4NuYXE2VJlMuvQeWVA80ZDFhpOPjSzhPa/MIGYMIGApH4wfDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
# bWUtU3RhbXAgUENBIDIwMTACEzMAAAHPUja+cUvNSMoAAQAAAc8wIgQgPIlQ6giZ
# 4RFqMhcc1nPilPamIt0zsHAXvoOv7Xz57o4wDQYJKoZIhvcNAQELBQAEggIAPdcD
# kbYdqmKTDsPJFUDQHtUq1ybj0bBhcRT8Q+DBJUWmRypDtQ7/bKRxzqNsxv8aKqWY
# UyFICY+ZKQnJ5OguHlzPKia73FggS66Y5snQIl26ri3CbmQmJIp0Og15byrB+jBz
# zyiFB/JSAgO/m5MuoBkHTLpiIX7BcYYN1J6ML5oABCsSSmSJBbUZAIlMQVpOwbcJ
# MU/Sq9dhZUzSPLu295Z61tBxUtwOWCAU5z1sYNCNYC5DTtH/lHbc+/UR0xUFl6dA
# Wg2paEqCtIPxB44o6X6LBe04bbkxQwZPilNR3XdnrKOgFPDjTdbbRT8EcCdn4lQa
# VGNDJijA0T1D64JPOdSlNqW9t1F7JhfaTUJE52e0eQBzbm3mljOL3t9b0Xk17Oo6
# UjBcuRep/MhVY0PuqA3e1rZiRB48wJcHibGVb6L7ObcsWCPyULhvvcs+CxpdZV6p
# EcHfsjkeNG6M2js64FHiA0pd9zJrztUM9FiAMsAQD+/KgzyN3/poQRtJwsymmVv/
# Wd/tP+hJRguZ6DTw1/5QCam5AOBayaNH9DJ/mtcfaWPqFoaduiBofKVSwcKZPM58
# PMujpml3Ks8VhlNnN1f0V0uXtslAyB3nDZXlJ+S2DM1OU+glLLBa8UkEIsOKwz3M
# bg2vbrhBHobP9ByKKoIzmRK12Q1jG2q6XpBAOVo=
# SIG # End signature block
