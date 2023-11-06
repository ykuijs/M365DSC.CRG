return @{
    MSFT_AAD = @(
        @{
            ClassName = 'MSFT_AADApplicationPermission'
            Attributes = @(
                @{
                    Name = 'Name'
                    ValueMap = $null
                    Description = 'Name of the requested permission.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'SourceAPI'
                    ValueMap = $null
                    Description = 'Name of the API from which the permission comes from.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'Type'
                    ValueMap = @(
                        'AppOnly'
                        'Delegated'
                    )
                    Description = 'Type of permission.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'AdminConsentGranted'
                    ValueMap = $null
                    Description = 'Represented whether or not the Admin consent been granted on the app.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
            )
            ClassVersion = '1.0.0'
            FriendlyName = $null
        }
        @{
            ClassName = 'MSFT_AADApplication'
            Attributes = @(
                @{
                    Name = 'DisplayName'
                    ValueMap = $null
                    Description = 'DisplayName of the app'
                    DataType = 'String'
                    State = 'Key'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'ObjectId'
                    ValueMap = $null
                    Description = 'ObjectID of the app.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'AppId'
                    ValueMap = $null
                    Description = 'AppId for the app.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'AvailableToOtherTenants'
                    ValueMap = $null
                    Description = 'Indicates whether this application is available in other tenants.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'GroupMembershipClaims'
                    ValueMap = $null
                    Description = 'A bitmask that configures the groups claim issued in a user or OAuth 2.0 access token that the application expects. The bitmask values are: 0: None, 1: Security groups and Azure AD roles, 2: Reserved, and 4: Reserved. Setting the bitmask to 7 will get all of the security groups, distribution groups, and Azure AD directory roles that the signed-in user is a member of.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'Homepage'
                    ValueMap = $null
                    Description = 'The URL to the application''s homepage.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'IdentifierUris'
                    ValueMap = $null
                    Description = 'User-defined URI(s) that uniquely identify a Web application within its Azure AD tenant, or within a verified custom domain.'
                    DataType = 'StringArray'
                    State = 'Write'
                    IsArray = $true
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'KnownClientApplications'
                    ValueMap = $null
                    Description = 'Client applications that are tied to this resource application.'
                    DataType = 'StringArray'
                    State = 'Write'
                    IsArray = $true
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'LogoutURL'
                    ValueMap = $null
                    Description = 'The logout url for this application.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'PublicClient'
                    ValueMap = $null
                    Description = 'Specifies whether this application is a public client (such as an installed application running on a mobile device). Default is false.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'ReplyURLs'
                    ValueMap = $null
                    Description = 'Specifies the URLs that user tokens are sent to for sign in, or the redirect URIs that OAuth 2.0 authorization codes and access tokens are sent to.'
                    DataType = 'StringArray'
                    State = 'Write'
                    IsArray = $true
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'Owners'
                    ValueMap = $null
                    Description = 'UPN or ObjectID values of the app''s owners.'
                    DataType = 'StringArray'
                    State = 'Write'
                    IsArray = $true
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'Ensure'
                    ValueMap = @(
                        'Present'
                        'Absent'
                    )
                    Description = 'Specify if the Azure AD App should exist or not.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'Credential'
                    ValueMap = $null
                    Description = 'Credentials for the Microsoft Graph delegated permissions.'
                    DataType = 'Instance'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = 'MSFT_Credential'
                }
                @{
                    Name = 'ApplicationId'
                    ValueMap = $null
                    Description = 'Id of the Azure Active Directory application to authenticate with.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'ApplicationSecret'
                    ValueMap = $null
                    Description = 'Secret of the Azure Active Directory application to authenticate with.'
                    DataType = 'Instance'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = 'MSFT_Credential'
                }
                @{
                    Name = 'TenantId'
                    ValueMap = $null
                    Description = 'Id of the Azure Active Directory tenant used for authentication.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'Permissions'
                    ValueMap = $null
                    Description = 'API permissions for the Azure Active Directory Application.'
                    DataType = 'InstanceArray'
                    State = 'Write'
                    IsArray = $true
                    EmbeddedInstance = 'MSFT_AADApplicationPermission'
                }
                @{
                    Name = 'CertificateThumbprint'
                    ValueMap = $null
                    Description = 'Thumbprint of the Azure Active Directory application''s authentication certificate to use for authentication.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'ManagedIdentity'
                    ValueMap = $null
                    Description = 'Managed ID being used for authentication.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
            )
            ClassVersion = '1.0.0.0'
            FriendlyName = 'AADApplication'
        }
    )
    MSFT_EXO = @(
        @{
            ClassName = 'MSFT_EXOAcceptedDomain'
            Attributes = @(
                @{
                    Name = 'Identity'
                    ValueMap = $null
                    Description = 'Specify the Fully Qualified Domain Name for the AcceptedDomain.'
                    DataType = 'String'
                    State = 'Key'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'Ensure'
                    ValueMap = @(
                        'Present'
                        'Absent'
                    )
                    Description = 'Specify if the AcceptedDomain should exist or not.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'DomainType'
                    ValueMap = @(
                        'Authoritative'
                        'InternalRelay'
                    )
                    Description = 'The type of AcceptedDomain.  Currently the EXOAcceptedDomain DSC Resource accepts a value of ''Authoritative'' and ''InternalRelay''.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'MatchSubDomains'
                    ValueMap = $null
                    Description = 'The MatchSubDomains parameter must be false on Authoritative domains. The default value is false.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'OutboundOnly'
                    ValueMap = $null
                    Description = 'OutboundOnly can only be enabled if the DomainType parameter is set to Authoritative or InternalRelay. The default value is false.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'Credential'
                    ValueMap = $null
                    Description = 'Credentials of the Exchange Global Admin'
                    DataType = 'Instance'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = 'MSFT_Credential'
                }
                @{
                    Name = 'ApplicationId'
                    ValueMap = $null
                    Description = 'Id of the Azure Active Directory application to authenticate with.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'TenantId'
                    ValueMap = $null
                    Description = 'Id of the Azure Active Directory tenant used for authentication.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'CertificateThumbprint'
                    ValueMap = $null
                    Description = 'Thumbprint of the Azure Active Directory application''s authentication certificate to use for authentication.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'CertificatePassword'
                    ValueMap = $null
                    Description = 'Username can be made up to anything but password will be used for CertificatePassword'
                    DataType = 'Instance'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = 'MSFT_Credential'
                }
                @{
                    Name = 'CertificatePath'
                    ValueMap = $null
                    Description = 'Path to certificate used in service principal usually a PFX file.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'ManagedIdentity'
                    ValueMap = $null
                    Description = 'Managed ID being used for authentication.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
            )
            ClassVersion = '1.0.0.0'
            FriendlyName = 'EXOAcceptedDomain'
        }
    )
    MSFT_Intune = @(
        @{
            ClassName = 'MSFT_IntuneAntivirusPolicyWindows10SettingCatalog'
            Attributes = @(
                @{
                    Name = 'DisplayName'
                    ValueMap = $null
                    Description = 'Display name of the endpoint protection policy for Windows 10.'
                    DataType = 'String'
                    State = 'Key'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'Identity'
                    ValueMap = $null
                    Description = 'Identity of the endpoint protection policy for Windows 10.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'Description'
                    ValueMap = $null
                    Description = 'Description of the endpoint protection policy for Windows 10.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'tamperprotection'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Allows or disallows scanning of archives. (0: enable feature. 1: disable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'disableaccountprotectionui'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Use this policy setting to specify if to display the Account protection area in Windows Defender Security Center. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'disableappbrowserui'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Use this policy setting if you want to disable the display of the app and browser protection area in Windows Defender Security Center. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'disablecleartpmbutton'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Disable the Clear TPM button in Windows Security. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'disabledevicesecurityui'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Use this policy setting if you want to disable the display of the Device security area in the Windows Defender Security Center. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'disablefamilyui'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Use this policy setting if you want to disable the display of the family options area in Windows Defender Security Center. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'disablehealthui'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Use this policy setting if you want to disable the display of the device performance and health area in Windows Defender Security Center. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'disablenetworkui'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Use this policy setting if you want to disable the display of the firewall and network protection area in Windows Defender Security Center. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'disableenhancednotifications'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Use this policy setting if you want to disable the display of Windows Defender Security Center notifications. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'disabletpmfirmwareupdatewarning'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Hide the recommendation to update TPM Firmware when a vulnerable firmware is detected. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'disablevirusui'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Use this policy setting if you want to disable the display of the virus and threat protection area in Windows Defender Security Center.  (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'hideransomwaredatarecovery'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Use this policy setting to hide the Ransomware data recovery area in Windows Defender Security Center. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'hidewindowssecuritynotificationareacontrol'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'This policy setting hides the Windows Security notification area control. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'enablecustomizedtoasts'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Enable this policy to display your company name and contact options in the notifications. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'enableinappcustomization'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Enable this policy to have your company name and contact options displayed in a contact card fly out in Windows Defender Security Center. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'companyname'
                    ValueMap = $null
                    Description = 'The company name that is displayed to the users. CompanyName is required for both EnableCustomizedToasts and EnableInAppCustomization.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'email'
                    ValueMap = $null
                    Description = 'The email address that is displayed to users. The default mail application is used to initiate email actions.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'phone'
                    ValueMap = $null
                    Description = 'The phone number or Skype ID that is displayed to users. Skype is used to initiate the call.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'url'
                    ValueMap = $null
                    Description = 'The help portal URL that is displayed to users. The default browser is used to initiate this action.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'allowarchivescanning'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Allows or disallows scanning of archives. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'allowbehaviormonitoring'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Allows or disallows Windows Defender Behavior Monitoring functionality. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'allowcloudprotection'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'To best protect your PC, Windows Defender will send information to Microsoft about any problems it finds. Microsoft will analyze that information, learn more about problems affecting you and other customers, and offer improved solutions. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'allowemailscanning'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Allows or disallows scanning of email.  (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'allowfullscanonmappednetworkdrives'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Allows or disallows a full scan of mapped network drives. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'allowfullscanremovabledrivescanning'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Allows or disallows a full scan of removable drives. During a quick scan, removable drives may still be scanned. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'allowintrusionpreventionsystem'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'https://github.com/MicrosoftDocs/memdocs/issues/2250 (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'allowioavprotection'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Allows or disallows Windows Defender IOAVP Protection functionality. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'allowrealtimemonitoring'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Allows or disallows Windows Defender real-time Monitoring functionality. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'allowscanningnetworkfiles'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Allows or disallows a scanning of network files. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'allowscriptscanning'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Allows or disallows Windows Defender Script Scanning functionality. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'allowuseruiaccess'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Allows or disallows user access to the Windows Defender UI. I disallowed, all Windows Defender notifications will also be suppressed. (0: Prevents users from accessing UI. 1: Lets users access UI)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'avgcpuloadfactor'
                    ValueMap = $null
                    Description = 'Represents the average CPU load factor for the Windows Defender scan (in percent).'
                    DataType = 'SInt32'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'checkforsignaturesbeforerunningscan'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'This policy setting allows you to manage whether a check for new virus and spyware definitions will occur before running a scan. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'cloudblocklevel'
                    ValueMap = @(
                        '0'
                        '2'
                        '4'
                        '6'
                    )
                    Description = 'This policy setting determines how aggressive Microsoft Defender Antivirus will be in blocking and scanning suspicious files. Value type is integer.(0: Default windows defender blocking level, 2: High blocking level, 4:High+ blocking level, 6:Zero tolerance blocking level)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'cloudextendedtimeout'
                    ValueMap = $null
                    Description = 'This feature allows Microsoft Defender Antivirus to block a suspicious file for up to 60 seconds, and scan it in the cloud to make sure it''s safe. Value type is integer, range is 0 - 50.'
                    DataType = 'SInt32'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'daystoretaincleanedmalware'
                    ValueMap = $null
                    Description = 'Time period (in days) that quarantine items will be stored on the system.'
                    DataType = 'SInt32'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'disablecatchupfullscan'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'This policy setting allows you to configure catch-up scans for scheduled full scans.  (1: disabled, 0: enabled)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'disablecatchupquickscan'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'This policy setting allows you to configure catch-up scans for scheduled quick scans.  (1: disabled, 0: enabled)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'enablelowcpupriority'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'This policy setting allows you to enable or disable low CPU priority for scheduled scans. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'enablenetworkprotection'
                    ValueMap = @(
                        '0'
                        '1'
                        '2'
                    )
                    Description = 'This policy allows you to turn on network protection (block/audit) or off. (0: disabled, 1: block mode, 2: audit mode)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'excludedextensions'
                    ValueMap = $null
                    Description = 'Allows an administrator to specify a list of file type extensions to ignore during a scan.'
                    DataType = 'StringArray'
                    State = 'Write'
                    IsArray = $true
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'excludedpaths'
                    ValueMap = $null
                    Description = 'Allows an administrator to specify a list of directory paths to ignore during a scan.'
                    DataType = 'StringArray'
                    State = 'Write'
                    IsArray = $true
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'excludedprocesses'
                    ValueMap = $null
                    Description = 'Allows an administrator to specify a list of files opened by processes to ignore during a scan.'
                    DataType = 'StringArray'
                    State = 'Write'
                    IsArray = $true
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'puaprotection'
                    ValueMap = @(
                        '0'
                        '1'
                        '2'
                    )
                    Description = 'Specifies the level of detection for potentially unwanted applications (PUAs). (0: disabled, 1: block mode, 2: audit mode)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'engineupdateschannel'
                    ValueMap = @(
                        '0'
                        '2'
                        '3'
                        '4'
                        '5'
                        '6'
                    )
                    Description = 'Enable this policy to specify when devices receive Microsoft Defender engine updates during the monthly gradual rollout. (0: Not configured, 2: Beta Channel, 3: Current Channel (Preview), 4: Current Channel (Staged), 5: Current Channel (Broad), 6: Critical)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'platformupdateschannel'
                    ValueMap = @(
                        '0'
                        '2'
                        '3'
                        '4'
                        '5'
                        '6'
                    )
                    Description = 'Enable this policy to specify when devices receive Microsoft Defender platform updates during the monthly gradual rollout. (0: Not configured, 2: Beta Channel, 3: Current Channel (Preview), 4: Current Channel (Staged), 5: Current Channel (Broad), 6: Critical)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'securityintelligenceupdateschannel'
                    ValueMap = @(
                        '0'
                        '4'
                        '5'
                    )
                    Description = 'Enable this policy to specify when devices receive Microsoft Defender security intelligence updates during the daily gradual rollout. (0: Not configured, 4: Current Channel (Staged), 5: Current Channel (Broad))'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'realtimescandirection'
                    ValueMap = @(
                        '0'
                        '1'
                        '2'
                    )
                    Description = 'Controls which sets of files should be monitored. (0: Monitor all files (bi-directional), 1: Monitor incoming files, 2: Monitor outgoing files)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'scanparameter'
                    ValueMap = @(
                        '1'
                        '2'
                    )
                    Description = 'Selects whether to perform a quick scan or full scan. (1: Quick scan, 2: Full scan)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'schedulequickscantime'
                    ValueMap = $null
                    Description = 'Selects the time of day that the Windows Defender quick scan should run.'
                    DataType = 'SInt32'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'schedulescanday'
                    ValueMap = @(
                        '0'
                        '1'
                        '2'
                        '3'
                        '4'
                        '5'
                        '6'
                        '7'
                        '8'
                    )
                    Description = 'Selects the day that the Windows Defender scan should run. (0: Every day, 1: Sunday, 2: Monday, 3: Tuesday, 4: Wednesday, 5: Thursday, 6: Friday, 7: Saturday, 8: No scheduled scan)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'schedulescantime'
                    ValueMap = $null
                    Description = 'Selects the time of day that the Windows Defender scan should run.'
                    DataType = 'SInt32'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'signatureupdatefallbackorder'
                    ValueMap = $null
                    Description = 'This policy setting allows you to define the order in which different definition update sources should be contacted.'
                    DataType = 'StringArray'
                    State = 'Write'
                    IsArray = $true
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'signatureupdatefilesharessources'
                    ValueMap = $null
                    Description = 'This policy setting allows you to configure UNC file share sources for downloading definition updates.'
                    DataType = 'StringArray'
                    State = 'Write'
                    IsArray = $true
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'signatureupdateinterval'
                    ValueMap = $null
                    Description = 'Specifies the interval (in hours) that will be used to check for signatures, so instead of using the ScheduleDay and ScheduleTime the check for new signatures will be set according to the interval.'
                    DataType = 'SInt32'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'submitsamplesconsent'
                    ValueMap = @(
                        '0'
                        '1'
                        '2'
                        '3'
                    )
                    Description = 'Checks for the user consent level in Windows Defender to send data. (0: Always prompt, 1: Send safe samples automatically, 2: Never send, 3: Send all samples automatically)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'disablelocaladminmerge'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'This policy setting controls whether or not complex list settings configured by a local administrator are merged with managed settings. (0: enable local admin merge, 1: disable local admin merge)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'allowonaccessprotection'
                    ValueMap = @(
                        '0'
                        '1'
                    )
                    Description = 'Allows or disallows Windows Defender On Access Protection functionality. (0: disable feature. 1: enable feature)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'lowseveritythreats'
                    ValueMap = @(
                        'clean'
                        'quarantine'
                        'remove'
                        'allow'
                        'userdefined'
                        'block'
                    )
                    Description = 'Allows an administrator to specify low severity threats corresponding action ID to take.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'moderateseveritythreats'
                    ValueMap = @(
                        'clean'
                        'quarantine'
                        'remove'
                        'allow'
                        'userdefined'
                        'block'
                    )
                    Description = 'Allows an administrator to specify moderate severity threats corresponding action ID to take.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'severethreats'
                    ValueMap = @(
                        'clean'
                        'quarantine'
                        'remove'
                        'allow'
                        'userdefined'
                        'block'
                    )
                    Description = 'Allows an administrator to specify high severity threats corresponding action ID to take.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'highseveritythreats'
                    ValueMap = @(
                        'clean'
                        'quarantine'
                        'remove'
                        'allow'
                        'userdefined'
                        'block'
                    )
                    Description = 'Allows an administrator to specify severe threats corresponding action ID to take.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'templateId'
                    ValueMap = @(
                        'd948ff9b-99cb-4ee0-8012-1fbc09685377_1'
                        'e3f74c5a-a6de-411d-aef6-eb15628f3a0a_1'
                        '45fea5e9-280d-4da1-9792-fb5736da0ca9_1'
                        '804339ad-1553-4478-a742-138fb5807418_1'
                    )
                    Description = 'Template Id of the policy.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'Assignments'
                    ValueMap = $null
                    Description = 'Represents the assignment to the Intune policy.'
                    DataType = 'InstanceArray'
                    State = 'Write'
                    IsArray = $true
                    EmbeddedInstance = 'MSFT_DeviceManagementConfigurationPolicyAssignments'
                }
                @{
                    Name = 'Ensure'
                    ValueMap = @(
                        'Present'
                        'Absent'
                    )
                    Description = 'Present ensures the policy exists, absent ensures it is removed'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'Credential'
                    ValueMap = $null
                    Description = 'Credentials of the Intune Admin'
                    DataType = 'Instance'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = 'MSFT_Credential'
                }
                @{
                    Name = 'ApplicationId'
                    ValueMap = $null
                    Description = 'Id of the Azure Active Directory application to authenticate with.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'TenantId'
                    ValueMap = $null
                    Description = 'Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'ApplicationSecret'
                    ValueMap = $null
                    Description = 'Secret of the Azure Active Directory tenant used for authentication.'
                    DataType = 'Instance'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = 'MSFT_Credential'
                }
                @{
                    Name = 'CertificateThumbprint'
                    ValueMap = $null
                    Description = 'Thumbprint of the Azure Active Directory application''s authentication certificate to use for authentication.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'ManagedIdentity'
                    ValueMap = $null
                    Description = 'Managed ID being used for authentication.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
            )
            ClassVersion = '1.0.0.0'
            FriendlyName = 'IntuneAntivirusPolicyWindows10SettingCatalog'
        }
        @{
            ClassName = 'MSFT_DeviceManagementConfigurationPolicyAssignments'
            Attributes = @(
                @{
                    Name = 'dataType'
                    ValueMap = @(
                        '#microsoft.graph.groupAssignmentTarget'
                        '#microsoft.graph.allLicensedUsersAssignmentTarget'
                        '#microsoft.graph.allDevicesAssignmentTarget'
                        '#microsoft.graph.exclusionGroupAssignmentTarget'
                        '#microsoft.graph.configurationManagerCollectionAssignmentTarget'
                    )
                    Description = 'The type of the target assignment.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'deviceAndAppManagementAssignmentFilterType'
                    ValueMap = @(
                        'none'
                        'include'
                        'exclude'
                    )
                    Description = 'The type of filter of the target assignment i.e. Exclude or Include. Possible values are:none, include, exclude.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'deviceAndAppManagementAssignmentFilterId'
                    ValueMap = $null
                    Description = 'The Id of the filter for the target assignment.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'groupId'
                    ValueMap = $null
                    Description = 'The group Id that is the target of the assignment.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'collectionId'
                    ValueMap = $null
                    Description = 'The collection Id that is the target of the assignment.(ConfigMgr)'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
            )
            ClassVersion = '1.0.0.0'
            FriendlyName = $null
        }
    )
    MSFT_O365 = @(
        @{
            ClassName = 'MSFT_O365AdminAuditLogConfig'
            Attributes = @(
                @{
                    Name = 'IsSingleInstance'
                    ValueMap = 'Yes'
                    Description = 'Specifies the resource is a single instance, the value must be ''Yes'''
                    DataType = 'String'
                    State = 'Key'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'Ensure'
                    ValueMap = 'Present'
                    Description = '''Present'' is the only value accepted.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'UnifiedAuditLogIngestionEnabled'
                    ValueMap = @(
                        'Enabled'
                        'Disabled'
                    )
                    Description = 'Determins if Unified Audit Log Ingestion is enabled'
                    DataType = 'String'
                    State = 'Required'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'Credential'
                    ValueMap = $null
                    Description = 'Credentials of the Exchange Global Admin'
                    DataType = 'Instance'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = 'MSFT_Credential'
                }
                @{
                    Name = 'ApplicationId'
                    ValueMap = $null
                    Description = 'Id of the Azure Active Directory application to authenticate with.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'TenantId'
                    ValueMap = $null
                    Description = 'Id of the Azure Active Directory tenant used for authentication.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'CertificateThumbprint'
                    ValueMap = $null
                    Description = 'Thumbprint of the Azure Active Directory application''s authentication certificate to use for authentication.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'CertificatePassword'
                    ValueMap = $null
                    Description = 'Username can be made up to anything but password will be used for CertificatePassword'
                    DataType = 'Instance'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = 'MSFT_Credential'
                }
                @{
                    Name = 'CertificatePath'
                    ValueMap = $null
                    Description = 'Path to certificate used in service principal usually a PFX file.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'ManagedIdentity'
                    ValueMap = $null
                    Description = 'Managed ID being used for authentication.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
            )
            ClassVersion = '1.0.0.0'
            FriendlyName = 'O365AdminAuditLogConfig'
        }
    )
    MSFT_OD = @(
        @{
            ClassName = 'MSFT_ODSettings'
            Attributes = @(
                @{
                    Name = 'IsSingleInstance'
                    ValueMap = 'Yes'
                    Description = 'Should be set to yes'
                    DataType = 'String'
                    State = 'Key'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'OneDriveStorageQuota'
                    ValueMap = $null
                    Description = 'The resource quota to apply to the OneDrive sites'
                    DataType = 'UInt32'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'OrphanedPersonalSitesRetentionPeriod'
                    ValueMap = $null
                    Description = 'Number of days after a user''s account is deleted that their OneDrive for Business content will be deleted.'
                    DataType = 'UInt32'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'OneDriveForGuestsEnabled'
                    ValueMap = $null
                    Description = 'Enable guest acess for OneDrive'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'NotifyOwnersWhenInvitationsAccepted'
                    ValueMap = $null
                    Description = 'When true and when an external user accepts an invitation to a resource in a userâs OneDrive for Business owner is notified by e-mail'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'NotificationsInOneDriveForBusinessEnabled'
                    ValueMap = $null
                    Description = 'Turn notifications on/off OneDrive'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'ODBMembersCanShare'
                    ValueMap = @(
                        'On'
                        'Off'
                        'Unspecified'
                    )
                    Description = 'Lets administrators set policy on re-sharing behavior in OneDrive for Business'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'ODBAccessRequests'
                    ValueMap = @(
                        'On'
                        'Off'
                        'Unspecified'
                    )
                    Description = 'Lets administrators set policy on access requests and requests to share in OneDrive for Business'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'BlockMacSync'
                    ValueMap = $null
                    Description = 'Block sync client on Mac'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'DisableReportProblemDialog'
                    ValueMap = $null
                    Description = 'Disable dialog box'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'TenantRestrictionEnabled'
                    ValueMap = $null
                    Description = 'Enable/disable Safe domain List - if disabled overrides DomainGuids value'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'DomainGuids'
                    ValueMap = $null
                    Description = 'Safe domain list'
                    DataType = 'StringArray'
                    State = 'Write'
                    IsArray = $true
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'ExcludedFileExtensions'
                    ValueMap = $null
                    Description = 'Exclude files from being synced to OneDrive'
                    DataType = 'StringArray'
                    State = 'Write'
                    IsArray = $true
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'GrooveBlockOption'
                    ValueMap = @(
                        'OptOut'
                        'HardOptIn'
                        'SoftOptIn'
                    )
                    Description = 'Groove block options'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'Ensure'
                    ValueMap = @(
                        'Present'
                        'Absent'
                    )
                    Description = 'Present ensures the user exists, absent ensures it is removed'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'Credential'
                    ValueMap = $null
                    Description = 'Credentials of the account to authenticate with.'
                    DataType = 'Instance'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = 'MSFT_Credential'
                }
                @{
                    Name = 'ApplicationId'
                    ValueMap = $null
                    Description = 'Id of the Azure Active Directory application to authenticate with.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'TenantId'
                    ValueMap = $null
                    Description = 'Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'CertificatePassword'
                    ValueMap = $null
                    Description = 'Username can be made up to anything but password will be used for certificatePassword'
                    DataType = 'Instance'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = 'MSFT_Credential'
                }
                @{
                    Name = 'CertificatePath'
                    ValueMap = $null
                    Description = 'Path to certificate used in service principal usually a PFX file.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'CertificateThumbprint'
                    ValueMap = $null
                    Description = 'Thumbprint of the Azure Active Directory application''s authentication certificate to use for authentication.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'ManagedIdentity'
                    ValueMap = $null
                    Description = 'Managed ID being used for authentication.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
            )
            ClassVersion = '1.0.0.0'
            FriendlyName = 'ODSettings'
        }
    )
    MSFT_Planner = @(
        @{
            ClassName = 'MSFT_PlannerPlan'
            Attributes = @(
                @{
                    Name = 'Title'
                    ValueMap = $null
                    Description = 'The Title of the Planner Plan.'
                    DataType = 'String'
                    State = 'Key'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'OwnerGroup'
                    ValueMap = $null
                    Description = 'Name of Id of the Azure Active Directory Group who owns the plan'
                    DataType = 'String'
                    State = 'Key'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'Ensure'
                    ValueMap = @(
                        'Present'
                        'Absent'
                    )
                    Description = 'Present ensures the Plan exists, absent ensures it is removed'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'Credential'
                    ValueMap = $null
                    Description = 'Credentials of the account to authenticate with.'
                    DataType = 'Instance'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = 'MSFT_Credential'
                }
                @{
                    Name = 'ApplicationId'
                    ValueMap = $null
                    Description = 'Id of the Azure Active Directory application to authenticate with.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'TenantId'
                    ValueMap = $null
                    Description = 'Id of the Azure Active Directory tenant used for authentication.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'ApplicationSecret'
                    ValueMap = $null
                    Description = 'Secret of the Azure Active Directory tenant used for authentication.'
                    DataType = 'Instance'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = 'MSFT_Credential'
                }
                @{
                    Name = 'CertificateThumbprint'
                    ValueMap = $null
                    Description = 'Thumbprint of the Azure Active Directory application''s authentication certificate to use for authentication.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'ManagedIdentity'
                    ValueMap = $null
                    Description = 'Managed ID being used for authentication.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
            )
            ClassVersion = '1.0.0.0'
            FriendlyName = 'PlannerPlan'
        }
    )
    MSFT_PP = @(
        @{
            ClassName = 'MSFT_PPTenantSettings'
            Attributes = @(
                @{
                    Name = 'IsSingleInstance'
                    ValueMap = 'Yes'
                    Description = 'Should be set to yes'
                    DataType = 'String'
                    State = 'Key'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'WalkMeOptOut'
                    ValueMap = $null
                    Description = 'When set to true this will disable the Walk Me guidance.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'DisableNPSCommentsReachout'
                    ValueMap = $null
                    Description = 'When set to true this will disable the NPS Comments Reachout.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'DisableNewsletterSendout'
                    ValueMap = $null
                    Description = 'When set to true this will disable the monthly newsletters.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'DisableEnvironmentCreationByNonAdminUsers'
                    ValueMap = $null
                    Description = 'When set to true this will disable production environment creation by non-admin users.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'DisablePortalsCreationByNonAdminUsers'
                    ValueMap = $null
                    Description = 'When set to true this will disable portal creation by non-admin users.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'DisableSurveyFeedback'
                    ValueMap = $null
                    Description = 'When set to true this will disable survey feedback that sometimes pops up on top of an app.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'DisableTrialEnvironmentCreationByNonAdminUsers'
                    ValueMap = $null
                    Description = 'When set to true this will disable trial environment creation by non-admin users.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'DisableCapacityAllocationByEnvironmentAdmins'
                    ValueMap = $null
                    Description = 'When set to true this will disable capacity allocation by environment admins.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'DisableSupportTicketsVisibleByAllUsers'
                    ValueMap = $null
                    Description = 'When set to true this will disable support tickets to be visible by all users.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'DisableDocsSearch'
                    ValueMap = $null
                    Description = 'When set to true this will disable docs search in the Office 365 Suite navigation bar.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'DisableCommunitySearch'
                    ValueMap = $null
                    Description = 'When set to true this will disable community search in the Office 365 Suite navigation bar.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'DisableBingVideoSearch'
                    ValueMap = $null
                    Description = 'When set to true this will disable Bing video search in the Office 365 Suite navigation bar.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'DisableShareWithEveryone'
                    ValueMap = $null
                    Description = 'When set to true this will disable the ability to share apps with the whole tenant.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'EnableGuestsToMake'
                    ValueMap = $null
                    Description = 'When set to true this will enable the ability for guests in your tenant to create Power Platform resources.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'ShareWithColleaguesUserLimit'
                    ValueMap = $null
                    Description = 'The amount of people an app can be shared with in Dataverse for Teams (maximum is 10,000).'
                    DataType = 'UInt32'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'Credential'
                    ValueMap = $null
                    Description = 'Credentials of the Power Platform Admin'
                    DataType = 'Instance'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = 'MSFT_Credential'
                }
                @{
                    Name = 'ApplicationId'
                    ValueMap = $null
                    Description = 'Id of the Azure Active Directory application to authenticate with.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'TenantId'
                    ValueMap = $null
                    Description = 'Id of the Azure Active Directory tenant used for authentication.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'ApplicationSecret'
                    ValueMap = $null
                    Description = 'Secret of the Azure Active Directory tenant used for authentication.'
                    DataType = 'Instance'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = 'MSFT_Credential'
                }
                @{
                    Name = 'CertificateThumbprint'
                    ValueMap = $null
                    Description = 'Thumbprint of the Azure Active Directory application''s authentication certificate to use for authentication.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
            )
            ClassVersion = '1.0.0.0'
            FriendlyName = 'PPTenantSettings'
        }
    )
    MSFT_SC = @(
        @{
            ClassName = 'MSFT_SCAuditConfigurationPolicy'
            Attributes = @(
                @{
                    Name = 'Workload'
                    ValueMap = @(
                        'Exchange'
                        'SharePoint'
                        'OneDriveForBusiness'
                    )
                    Description = 'Workload associated with the policy.'
                    DataType = 'String'
                    State = 'Key'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'Ensure'
                    ValueMap = @(
                        'Present'
                        'Absent'
                    )
                    Description = 'Specify if this policy should exist or not.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'Credential'
                    ValueMap = $null
                    Description = 'Credentials of the Global Admin'
                    DataType = 'Instance'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = 'MSFT_Credential'
                }
                @{
                    Name = 'ApplicationId'
                    ValueMap = $null
                    Description = 'Id of the Azure Active Directory application to authenticate with.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'TenantId'
                    ValueMap = $null
                    Description = 'Id of the Azure Active Directory tenant used for authentication.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'CertificateThumbprint'
                    ValueMap = $null
                    Description = 'Thumbprint of the Azure Active Directory application''s authentication certificate to use for authentication.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'CertificatePassword'
                    ValueMap = $null
                    Description = 'Username can be made up to anything but password will be used for CertificatePassword'
                    DataType = 'Instance'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = 'MSFT_Credential'
                }
                @{
                    Name = 'CertificatePath'
                    ValueMap = $null
                    Description = 'Path to certificate used in service principal usually a PFX file.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
            )
            ClassVersion = '1.0.0.0'
            FriendlyName = 'SCAuditConfigurationPolicy'
        }
    )
    MSFT_SPO = @(
        @{
            ClassName = 'MSFT_SPOTenantSettings'
            Attributes = @(
                @{
                    Name = 'IsSingleInstance'
                    ValueMap = 'Yes'
                    Description = 'Specifies the resource is a single instance, the value must be ''Yes'''
                    DataType = 'String'
                    State = 'Key'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'MinCompatibilityLevel'
                    ValueMap = $null
                    Description = 'Specifies the lower bound on the compatibility level for new sites.'
                    DataType = 'UInt32'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'MaxCompatibilityLevel'
                    ValueMap = $null
                    Description = 'Specifies the upper bound on the compatibility level for new sites.'
                    DataType = 'UInt32'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'SearchResolveExactEmailOrUPN'
                    ValueMap = $null
                    Description = 'Removes the search capability from People Picker. Note, recently resolved names will still appear in the list until browser cache is cleared or expired.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'OfficeClientADALDisabled'
                    ValueMap = $null
                    Description = 'When set to true this will disable the ability to use Modern Authentication that leverages ADAL across the tenant.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'LegacyAuthProtocolsEnabled'
                    ValueMap = $null
                    Description = 'Setting this parameter prevents Office clients using non-modern authentication protocols from accessing SharePoint Online resources.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'SignInAccelerationDomain'
                    ValueMap = $null
                    Description = 'Specifies the home realm discovery value to be sent to Azure Active Directory (AAD) during the user sign-in process.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'UsePersistentCookiesForExplorerView'
                    ValueMap = $null
                    Description = 'Lets SharePoint issue a special cookie that will allow this feature to work even when Keep Me Signed In is not selected.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'UserVoiceForFeedbackEnabled'
                    ValueMap = $null
                    Description = 'Allow feedback via UserVoice.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'PublicCdnEnabled'
                    ValueMap = $null
                    Description = 'Configure PublicCDN'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'PublicCdnAllowedFileTypes'
                    ValueMap = $null
                    Description = 'Configure filetypes allowed for PublicCDN'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'UseFindPeopleInPeoplePicker'
                    ValueMap = $null
                    Description = 'When set to $true, users aren''t able to share with security groups or SharePoint groups'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'NotificationsInSharePointEnabled'
                    ValueMap = $null
                    Description = 'When set to $true, users aren''t able to share with security groups or SharePoint groups'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'OwnerAnonymousNotification'
                    ValueMap = $null
                    Description = ''
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'ApplyAppEnforcedRestrictionsToAdHocRecipients'
                    ValueMap = $null
                    Description = ''
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'FilePickerExternalImageSearchEnabled'
                    ValueMap = $null
                    Description = ''
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'HideDefaultThemes'
                    ValueMap = $null
                    Description = 'Defines if the default themes are visible or hidden'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'HideSyncButtonOnTeamSite'
                    ValueMap = $null
                    Description = 'To enable or disable Sync button on Team sites'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'MarkNewFilesSensitiveByDefault'
                    ValueMap = @(
                        'AllowExternalSharing'
                        'BlockExternalSharing'
                    )
                    Description = 'Allow or block external sharing until at least one Office DLP policy scans the content of the file.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'ConditionalAccessPolicy'
                    ValueMap = @(
                        'AllowFullAccess'
                        'AllowLimitedAccess'
                        'BlockAccess'
                    )
                    Description = 'Allow or Block Conditional Access Policy on the SharePoint Tenant'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'DisabledWebPartIds'
                    ValueMap = $null
                    Description = 'Provide GUID for the Web Parts that are to be disabled on the Sharepoint Site'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'CommentsOnSitePagesDisabled'
                    ValueMap = $null
                    Description = 'Set to false to enable a comment section on all site pages, users who have access to the pages can leave comments. Set to true to disable this feature.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'Ensure'
                    ValueMap = @(
                        'Present'
                        'Absent'
                    )
                    Description = 'Only accepted value is ''Present''.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'Credential'
                    ValueMap = $null
                    Description = 'Credentials of the account to authenticate with.'
                    DataType = 'Instance'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = 'MSFT_Credential'
                }
                @{
                    Name = 'ApplicationId'
                    ValueMap = $null
                    Description = 'Id of the Azure Active Directory application to authenticate with.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'ApplicationSecret'
                    ValueMap = $null
                    Description = 'Secret of the Azure Active Directory application to authenticate with.'
                    DataType = 'Instance'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = 'MSFT_Credential'
                }
                @{
                    Name = 'TenantId'
                    ValueMap = $null
                    Description = 'Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'CertificatePassword'
                    ValueMap = $null
                    Description = 'Username can be made up to anything but password will be used for certificatePassword'
                    DataType = 'Instance'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = 'MSFT_Credential'
                }
                @{
                    Name = 'CertificatePath'
                    ValueMap = $null
                    Description = 'Path to certificate used in service principal usually a PFX file.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'CertificateThumbprint'
                    ValueMap = $null
                    Description = 'Thumbprint of the Azure Active Directory application''s authentication certificate to use for authentication.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'ManagedIdentity'
                    ValueMap = $null
                    Description = 'Managed ID being used for authentication.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
            )
            ClassVersion = '1.0.0.0'
            FriendlyName = 'SPOTenantSettings'
        }
    )
    MSFT_Teams = @(
        @{
            ClassName = 'MSFT_TeamsClientConfiguration'
            Attributes = @(
                @{
                    Name = 'Identity'
                    ValueMap = 'Global'
                    Description = 'The only valid input is Global - the tenant wide configuration'
                    DataType = 'String'
                    State = 'Key'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'AllowBox'
                    ValueMap = $null
                    Description = 'Designates whether users are able to leverage Box as a third party storage solution in Microsoft Teams. If $true, users will be able to add Box in the client and interact with the files stored there.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'AllowDropBox'
                    ValueMap = $null
                    Description = 'Designates whether users are able to leverage DropBox as a third party storage solution in Microsoft Teams. If $true, users will be able to add DropBox in the client and interact with the files stored there.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'AllowEmailIntoChannel'
                    ValueMap = $null
                    Description = 'When set to $true, mail hooks are enabled, and users can post messages to a channel by sending an email to the email address of Teams channel.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'AllowGoogleDrive'
                    ValueMap = $null
                    Description = 'Designates whether users are able to leverage GoogleDrive as a third party storage solution in Microsoft Teams. If $true, users will be able to add Google Drive in the client and interact with the files stored there.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'AllowGuestUser'
                    ValueMap = $null
                    Description = 'Designates whether or not guest users in your organization will have access to the Teams client. If $true, guests in your tenant will be able to access the Teams client. Note that this setting has a core dependency on Guest Access being enabled in your Office 365 tenant.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'AllowOrganizationTab'
                    ValueMap = $null
                    Description = 'When set to $true, users will be able to see the organizational chart icon other users'' contact cards, and when clicked, this icon will display the detailed organizational chart.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'AllowResourceAccountSendMessage'
                    ValueMap = $null
                    Description = 'Surface Hub uses a device account to provide email and collaboration services (IM, video, voice). This device account is used as the originating identity (the from party) when sending email, IM, and placing calls. As this account is not coming from an individual, identifiable user, it is deemed anonymous because it originated from the Surface Hub''s device account. If set to $true, these device accounts will be able to send chat messages in Skype for Business Online (does not apply to Microsoft Teams).'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'AllowScopedPeopleSearchandAccess'
                    ValueMap = $null
                    Description = 'If set to $true, the Exchange address book policy (ABP) will be used to provide customized view of the global address book for each user. This is only a virtual separation and not a legal separation.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'AllowShareFile'
                    ValueMap = $null
                    Description = 'Designates whether users are able to leverage ShareFile as a third party storage solution in Microsoft Teams. If $true, users will be able to add ShareFile in the client and interact with the files stored there.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'AllowSkypeBusinessInterop'
                    ValueMap = $null
                    Description = 'When set to $true, Teams conversations automatically show up in Skype for Business for users that aren''t enabled for Teams.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'AllowEgnyte'
                    ValueMap = $null
                    Description = 'Designates whether users are able to leverage Egnyte as a third party storage solution in Microsoft Teams. If $true, users will be able to add Egnyte in the client and interact with the files stored there.'
                    DataType = 'Boolean'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'ContentPin'
                    ValueMap = @(
                        'NotRequired'
                        'RequiredOutsideScheduleMeeting'
                        'AlwaysRequired'
                    )
                    Description = 'This setting applies only to Skype for Business Online (not Microsoft Teams) and defines whether the user must provide a secondary form of authentication to access the meeting content from a resource device account. Meeting content is defined as files that are shared to the Content Bin - files that have been attached to the meeting.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'ResourceAccountContentAccess'
                    ValueMap = @(
                        'NoAccess'
                        'PartialAccess'
                        'FullAccess'
                    )
                    Description = 'Require a secondary form of authentication to access meeting content.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'RestrictedSenderList'
                    ValueMap = $null
                    Description = 'Senders domains can be further restricted to ensure that only allowed SMTP domains can send emails to the Teams channels. This is a comma-separated string of the domains you''d like to allow to send emails to Teams channels.'
                    DataType = 'StringArray'
                    State = 'Write'
                    IsArray = $true
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'Credential'
                    ValueMap = $null
                    Description = 'Credentials of the Teams Admin'
                    DataType = 'Instance'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = 'MSFT_Credential'
                }
                @{
                    Name = 'ApplicationId'
                    ValueMap = $null
                    Description = 'Id of the Azure Active Directory application to authenticate with.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'TenantId'
                    ValueMap = $null
                    Description = 'Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
                @{
                    Name = 'CertificateThumbprint'
                    ValueMap = $null
                    Description = 'Thumbprint of the Azure Active Directory application''s authentication certificate to use for authentication.'
                    DataType = 'String'
                    State = 'Write'
                    IsArray = $false
                    EmbeddedInstance = $null
                }
            )
            ClassVersion = '1.0.0.0'
            FriendlyName = 'TeamsClientConfiguration'
        }
    )
}
