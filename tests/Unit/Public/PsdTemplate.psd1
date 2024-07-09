@{
    AllNodes = @(
        @{
            NodeName = 'String | Required | Name of the host of which the LCM is used, normally this is localhost'
            CertificateFile = 'String | Required | Relative path to the public key of the DSC credential encryption certificate, e.g. .\DSCCertificate.cer'
        }
    )
    NonNodeData = @{
        Environment = @{
            OrganizationName = 'String | Required | Name of your organization, prefix of the tenant id, e.g. test'
            TenantId = 'String | Required | Tenant URL, e.g. test.onmicrosoft.com'
            Name = 'String | Required | Name of your environment, e.g. TestEnvironment'
            ShortName = 'String | Required | Abbreviation of the environment name, e.g. TST'
            CICD             = @{
                DependsOn     = 'String | Required | Name of the environment this environment depends on, e.g. TestEnvironment'
                UseCodeBranch = 'String | Required | Name of the branch that is used for the CICD (Script) repository, e.g. main'
                Approvers = @(
                    @{
                        Principal = 'String | Required | Principal of the user or groups that needs to get added to the approvers list.'
                        Type      = 'String | Required | Type of principal | User / Group'
                    }
                )
            }
            UsedWorkloads    = @{
                AzureAD            = 'Boolean | Required | Specifies if the workload should be included in the configuration'
                Exchange           = 'Boolean | Required | Specifies if the workload should be included in the configuration'
                Intune             = 'Boolean | Required | Specifies if the workload should be included in the configuration'
                Office365          = 'Boolean | Required | Specifies if the workload should be included in the configuration'
                OneDrive           = 'Boolean | Required | Specifies if the workload should be included in the configuration'
                Planner            = 'Boolean | Required | Specifies if the workload should be included in the configuration'
                PowerPlatform      = 'Boolean | Required | Specifies if the workload should be included in the configuration'
                SecurityCompliance = 'Boolean | Required | Specifies if the workload should be included in the configuration'
                SharePoint         = 'Boolean | Required | Specifies if the workload should be included in the configuration'
                Teams              = 'Boolean | Required | Specifies if the workload should be included in the configuration'
            }
            Tokens = @{
                ExampleToken = 'String | Optional | Example of a token that can be used anywhere in the config, by specifying {{ExampleToken}}'
            }
        }
        AppCredentials = @(
            @{
                ApplicationId = 'Guid | Required | The GUID of the Entra ID Service Principal'
                Workload = 'String | Required | Name of the Workload for which this credential will be used | AzureAD / Exchange / Intune / Office365 / OneDrive / Planner / PowerPlatform / SecurityCompliance / SharePoint / Teams'
                CertThumbprint = 'String | Required | The Certificate Thumbprint of the certificate used for authentication'
            }
        )
        AzureAD = @{
            Applications = @(
                @{
                    Owners = @(
                        'String | Optional | UPN or ObjectID values of the app''s owners.'
                    )
                    AvailableToOtherTenants = 'Boolean | Optional | Indicates whether this application is available in other tenants.'
                    GroupMembershipClaims = 'String | Optional | A bitmask that configures the groups claim issued in a user or OAuth 2.0 access token that the application expects. The bitmask values are: 0: None, 1: Security groups and Azure AD roles, 2: Reserved, and 4: Reserved. Setting the bitmask to 7 will get all of the security groups, distribution groups, and Azure AD directory roles that the signed-in user is a member of.'
                    ObjectId = 'String | Optional | ObjectID of the app.'
                    IdentifierUris = @(
                        'String | Optional | User-defined URI(s) that uniquely identify a Web application within its Azure AD tenant, or within a verified custom domain.'
                    )
                    UniqueId = 'String | Required | Unique ID to identify this specific object'
                    KnownClientApplications = @(
                        'String | Optional | Client applications that are tied to this resource application.'
                    )
                    DisplayName = 'String | Required | DisplayName of the app'
                    Permissions = @(
                        @{
                            AdminConsentGranted = 'Boolean | Optional | Represented whether or not the Admin consent been granted on the app.'
                            SourceAPI = 'String | Optional | Name of the API from which the permission comes from.'
                            Name = 'String | Optional | Name of the requested permission.'
                            UniqueId = 'String | Required | [Unique ID to identify this specific object]'
                            Type = 'String | Optional | Type of permission. | AppOnly / Delegated'
                        }
                    )
                    Ensure = 'String | Optional | Specify if the Azure AD App should exist or not. | Present / Absent'
                    ReplyURLs = @(
                        'String | Optional | Specifies the URLs that user tokens are sent to for sign in, or the redirect URIs that OAuth 2.0 authorization codes and access tokens are sent to.'
                    )
                    PublicClient = 'Boolean | Optional | Specifies whether this application is a public client (such as an installed application running on a mobile device). Default is false.'
                    AppId = 'String | Optional | AppId for the app.'
                    Homepage = 'String | Optional | The URL to the application''s homepage.'
                    LogoutURL = 'String | Optional | The logout url for this application.'
                }
            )
        }
        Exchange = @{
            AcceptedDomains = @(
                @{
                    MatchSubDomains = 'Boolean | Optional | The MatchSubDomains parameter must be false on Authoritative domains. The default value is false.'
                    DomainType = 'String | Optional | The type of AcceptedDomain.  Currently the EXOAcceptedDomain DSC Resource accepts a value of ''Authoritative'' and ''InternalRelay''. | Authoritative / InternalRelay'
                    Ensure = 'String | Optional | Specify if the AcceptedDomain should exist or not. | Present / Absent'
                    Identity = 'String | Required | Specify the Fully Qualified Domain Name for the AcceptedDomain.'
                    OutboundOnly = 'Boolean | Optional | OutboundOnly can only be enabled if the DomainType parameter is set to Authoritative or InternalRelay. The default value is false.'
                }
            )
        }
        Intune = @{
            AntivirusPoliciesWindows10SettingCatalog = @(
                @{
                    scanparameter = 'String | Optional | Selects whether to perform a quick scan or full scan. (1: Quick scan, 2: Full scan) | 1 / 2'
                    allowemailscanning = 'String | Optional | Allows or disallows scanning of email.  (0: disable feature. 1: enable feature) | 0 / 1'
                    hideransomwaredatarecovery = 'String | Optional | Use this policy setting to hide the Ransomware data recovery area in Windows Defender Security Center. (0: disable feature. 1: enable feature) | 0 / 1'
                    Identity = 'String | Optional | Identity of the endpoint protection policy for Windows 10.'
                    allowioavprotection = 'String | Optional | Allows or disallows Windows Defender IOAVP Protection functionality. (0: disable feature. 1: enable feature) | 0 / 1'
                    Assignments = @(
                        @{
                            deviceAndAppManagementAssignmentFilterId = 'String | Optional | The Id of the filter for the target assignment.'
                            groupId = 'String | Optional | The group Id that is the target of the assignment.'
                            deviceAndAppManagementAssignmentFilterType = 'String | Optional | The type of filter of the target assignment i.e. Exclude or Include. Possible values are:none, include, exclude. | none / include / exclude'
                            dataType = 'String | Optional | The type of the target assignment. | #microsoft.graph.groupAssignmentTarget / #microsoft.graph.allLicensedUsersAssignmentTarget / #microsoft.graph.allDevicesAssignmentTarget / #microsoft.graph.exclusionGroupAssignmentTarget / #microsoft.graph.configurationManagerCollectionAssignmentTarget'
                            UniqueId = 'String | Required | [Unique ID to identify this specific object]'
                            collectionId = 'String | Optional | The collection Id that is the target of the assignment.(ConfigMgr)'
                        }
                    )
                    hidewindowssecuritynotificationareacontrol = 'String | Optional | This policy setting hides the Windows Security notification area control. (0: disable feature. 1: enable feature) | 0 / 1'
                    schedulescantime = 'SInt32 | Optional | Selects the time of day that the Windows Defender scan should run.'
                    DisplayName = 'String | Required | Display name of the endpoint protection policy for Windows 10.'
                    Description = 'String | Optional | Description of the endpoint protection policy for Windows 10.'
                    disablenetworkui = 'String | Optional | Use this policy setting if you want to disable the display of the firewall and network protection area in Windows Defender Security Center. (0: disable feature. 1: enable feature) | 0 / 1'
                    severethreats = 'String | Optional | Allows an administrator to specify high severity threats corresponding action ID to take. | clean / quarantine / remove / allow / userdefined / block'
                    excludedprocesses = @(
                        'String | Optional | Allows an administrator to specify a list of files opened by processes to ignore during a scan.'
                    )
                    excludedpaths = @(
                        'String | Optional | Allows an administrator to specify a list of directory paths to ignore during a scan.'
                    )
                    daystoretaincleanedmalware = 'SInt32 | Optional | Time period (in days) that quarantine items will be stored on the system.'
                    allowarchivescanning = 'String | Optional | Allows or disallows scanning of archives. (0: disable feature. 1: enable feature) | 0 / 1'
                    companyname = 'String | Optional | The company name that is displayed to the users. CompanyName is required for both EnableCustomizedToasts and EnableInAppCustomization.'
                    schedulequickscantime = 'SInt32 | Optional | Selects the time of day that the Windows Defender quick scan should run.'
                    enableinappcustomization = 'String | Optional | Enable this policy to have your company name and contact options displayed in a contact card fly out in Windows Defender Security Center. (0: disable feature. 1: enable feature) | 0 / 1'
                    allowscriptscanning = 'String | Optional | Allows or disallows Windows Defender Script Scanning functionality. (0: disable feature. 1: enable feature) | 0 / 1'
                    signatureupdateinterval = 'SInt32 | Optional | Specifies the interval (in hours) that will be used to check for signatures, so instead of using the ScheduleDay and ScheduleTime the check for new signatures will be set according to the interval.'
                    signatureupdatefilesharessources = @(
                        'String | Optional | This policy setting allows you to configure UNC file share sources for downloading definition updates.'
                    )
                    disablecleartpmbutton = 'String | Optional | Disable the Clear TPM button in Windows Security. (0: disable feature. 1: enable feature) | 0 / 1'
                    cloudextendedtimeout = 'SInt32 | Optional | This feature allows Microsoft Defender Antivirus to block a suspicious file for up to 60 seconds, and scan it in the cloud to make sure it''s safe. Value type is integer, range is 0 - 50.'
                    allowscanningnetworkfiles = 'String | Optional | Allows or disallows a scanning of network files. (0: disable feature. 1: enable feature) | 0 / 1'
                    email = 'String | Optional | The email address that is displayed to users. The default mail application is used to initiate email actions.'
                    disablefamilyui = 'String | Optional | Use this policy setting if you want to disable the display of the family options area in Windows Defender Security Center. (0: disable feature. 1: enable feature) | 0 / 1'
                    avgcpuloadfactor = 'SInt32 | Optional | Represents the average CPU load factor for the Windows Defender scan (in percent).'
                    allowcloudprotection = 'String | Optional | To best protect your PC, Windows Defender will send information to Microsoft about any problems it finds. Microsoft will analyze that information, learn more about problems affecting you and other customers, and offer improved solutions. (0: disable feature. 1: enable feature) | 0 / 1'
                    moderateseveritythreats = 'String | Optional | Allows an administrator to specify moderate severity threats corresponding action ID to take. | clean / quarantine / remove / allow / userdefined / block'
                    allowrealtimemonitoring = 'String | Optional | Allows or disallows Windows Defender real-time Monitoring functionality. (0: disable feature. 1: enable feature) | 0 / 1'
                    allowuseruiaccess = 'String | Optional | Allows or disallows user access to the Windows Defender UI. I disallowed, all Windows Defender notifications will also be suppressed. (0: Prevents users from accessing UI. 1: Lets users access UI) | 0 / 1'
                    disablecatchupfullscan = 'String | Optional | This policy setting allows you to configure catch-up scans for scheduled full scans.  (1: disabled, 0: enabled) | 0 / 1'
                    excludedextensions = @(
                        'String | Optional | Allows an administrator to specify a list of file type extensions to ignore during a scan.'
                    )
                    disablecatchupquickscan = 'String | Optional | This policy setting allows you to configure catch-up scans for scheduled quick scans.  (1: disabled, 0: enabled) | 0 / 1'
                    disableappbrowserui = 'String | Optional | Use this policy setting if you want to disable the display of the app and browser protection area in Windows Defender Security Center. (0: disable feature. 1: enable feature) | 0 / 1'
                    disablehealthui = 'String | Optional | Use this policy setting if you want to disable the display of the device performance and health area in Windows Defender Security Center. (0: disable feature. 1: enable feature) | 0 / 1'
                    disableenhancednotifications = 'String | Optional | Use this policy setting if you want to disable the display of Windows Defender Security Center notifications. (0: disable feature. 1: enable feature) | 0 / 1'
                    enablecustomizedtoasts = 'String | Optional | Enable this policy to display your company name and contact options in the notifications. (0: disable feature. 1: enable feature) | 0 / 1'
                    engineupdateschannel = 'String | Optional | Enable this policy to specify when devices receive Microsoft Defender engine updates during the monthly gradual rollout. (0: Not configured, 2: Beta Channel, 3: Current Channel (Preview), 4: Current Channel (Staged), 5: Current Channel (Broad), 6: Critical) | 0 / 2 / 3 / 4 / 5 / 6'
                    phone = 'String | Optional | The phone number or Skype ID that is displayed to users. Skype is used to initiate the call.'
                    realtimescandirection = 'String | Optional | Controls which sets of files should be monitored. (0: Monitor all files (bi-directional), 1: Monitor incoming files, 2: Monitor outgoing files) | 0 / 1 / 2'
                    disableaccountprotectionui = 'String | Optional | Use this policy setting to specify if to display the Account protection area in Windows Defender Security Center. (0: disable feature. 1: enable feature) | 0 / 1'
                    tamperprotection = 'String | Optional | Allows or disallows scanning of archives. (0: enable feature. 1: disable feature) | 0 / 1'
                    highseveritythreats = 'String | Optional | Allows an administrator to specify severe threats corresponding action ID to take. | clean / quarantine / remove / allow / userdefined / block'
                    checkforsignaturesbeforerunningscan = 'String | Optional | This policy setting allows you to manage whether a check for new virus and spyware definitions will occur before running a scan. (0: disable feature. 1: enable feature) | 0 / 1'
                    schedulescanday = 'String | Optional | Selects the day that the Windows Defender scan should run. (0: Every day, 1: Sunday, 2: Monday, 3: Tuesday, 4: Wednesday, 5: Thursday, 6: Friday, 7: Saturday, 8: No scheduled scan) | 0 / 1 / 2 / 3 / 4 / 5 / 6 / 7 / 8'
                    allowfullscanremovabledrivescanning = 'String | Optional | Allows or disallows a full scan of removable drives. During a quick scan, removable drives may still be scanned. (0: disable feature. 1: enable feature) | 0 / 1'
                    disabletpmfirmwareupdatewarning = 'String | Optional | Hide the recommendation to update TPM Firmware when a vulnerable firmware is detected. (0: disable feature. 1: enable feature) | 0 / 1'
                    signatureupdatefallbackorder = @(
                        'String | Optional | This policy setting allows you to define the order in which different definition update sources should be contacted.'
                    )
                    enablenetworkprotection = 'String | Optional | This policy allows you to turn on network protection (block/audit) or off. (0: disabled, 1: block mode, 2: audit mode) | 0 / 1 / 2'
                    submitsamplesconsent = 'String | Optional | Checks for the user consent level in Windows Defender to send data. (0: Always prompt, 1: Send safe samples automatically, 2: Never send, 3: Send all samples automatically) | 0 / 1 / 2 / 3'
                    disabledevicesecurityui = 'String | Optional | Use this policy setting if you want to disable the display of the Device security area in the Windows Defender Security Center. (0: disable feature. 1: enable feature) | 0 / 1'
                    puaprotection = 'String | Optional | Specifies the level of detection for potentially unwanted applications (PUAs). (0: disabled, 1: block mode, 2: audit mode) | 0 / 1 / 2'
                    disablelocaladminmerge = 'String | Optional | This policy setting controls whether or not complex list settings configured by a local administrator are merged with managed settings. (0: enable local admin merge, 1: disable local admin merge) | 0 / 1'
                    allowintrusionpreventionsystem = 'String | Optional | https://github.com/MicrosoftDocs/memdocs/issues/2250 (0: disable feature. 1: enable feature) | 0 / 1'
                    url = 'String | Optional | The help portal URL that is displayed to users. The default browser is used to initiate this action.'
                    disablevirusui = 'String | Optional | Use this policy setting if you want to disable the display of the virus and threat protection area in Windows Defender Security Center.  (0: disable feature. 1: enable feature) | 0 / 1'
                    allowfullscanonmappednetworkdrives = 'String | Optional | Allows or disallows a full scan of mapped network drives. (0: disable feature. 1: enable feature) | 0 / 1'
                    platformupdateschannel = 'String | Optional | Enable this policy to specify when devices receive Microsoft Defender platform updates during the monthly gradual rollout. (0: Not configured, 2: Beta Channel, 3: Current Channel (Preview), 4: Current Channel (Staged), 5: Current Channel (Broad), 6: Critical) | 0 / 2 / 3 / 4 / 5 / 6'
                    templateId = 'String | Optional | Template Id of the policy. | d948ff9b-99cb-4ee0-8012-1fbc09685377_1 / e3f74c5a-a6de-411d-aef6-eb15628f3a0a_1 / 45fea5e9-280d-4da1-9792-fb5736da0ca9_1 / 804339ad-1553-4478-a742-138fb5807418_1'
                    securityintelligenceupdateschannel = 'String | Optional | Enable this policy to specify when devices receive Microsoft Defender security intelligence updates during the daily gradual rollout. (0: Not configured, 4: Current Channel (Staged), 5: Current Channel (Broad)) | 0 / 4 / 5'
                    allowonaccessprotection = 'String | Optional | Allows or disallows Windows Defender On Access Protection functionality. (0: disable feature. 1: enable feature) | 0 / 1'
                    lowseveritythreats = 'String | Optional | Allows an administrator to specify low severity threats corresponding action ID to take. | clean / quarantine / remove / allow / userdefined / block'
                    Ensure = 'String | Optional | Present ensures the policy exists, absent ensures it is removed | Present / Absent'
                    enablelowcpupriority = 'String | Optional | This policy setting allows you to enable or disable low CPU priority for scheduled scans. (0: disable feature. 1: enable feature) | 0 / 1'
                    allowbehaviormonitoring = 'String | Optional | Allows or disallows Windows Defender Behavior Monitoring functionality. (0: disable feature. 1: enable feature) | 0 / 1'
                    cloudblocklevel = 'String | Optional | This policy setting determines how aggressive Microsoft Defender Antivirus will be in blocking and scanning suspicious files. Value type is integer.(0: Default windows defender blocking level, 2: High blocking level, 4:High+ blocking level, 6:Zero tolerance blocking level) | 0 / 2 / 4 / 6'
                }
            )
        }
        Office365 = @{
            AdminAuditLogConfig = @{
                UnifiedAuditLogIngestionEnabled = 'String | Required | Determins if Unified Audit Log Ingestion is enabled | Enabled / Disabled'
                Ensure = 'String | Optional | ''Present'' is the only value accepted. | Present'
            }
        }
        OneDrive = @{
            Settings = @{
                ODBAccessRequests = 'String | Optional | Lets administrators set policy on access requests and requests to share in OneDrive for Business | On / Off / Unspecified'
                NotifyOwnersWhenInvitationsAccepted = 'Boolean | Optional | When true and when an external user accepts an invitation to a resource in a users OneDrive for Business owner is notified by e-mail'
                GrooveBlockOption = 'String | Optional | Groove block options | OptOut / HardOptIn / SoftOptIn'
                TenantRestrictionEnabled = 'Boolean | Optional | Enable/disable Safe domain List - if disabled overrides DomainGuids value'
                DisableReportProblemDialog = 'Boolean | Optional | Disable dialog box'
                ODBMembersCanShare = 'String | Optional | Lets administrators set policy on re-sharing behavior in OneDrive for Business | On / Off / Unspecified'
                Ensure = 'String | Optional | Present ensures the user exists, absent ensures it is removed | Present / Absent'
                OrphanedPersonalSitesRetentionPeriod = 'UInt32 | Optional | Number of days after a user''s account is deleted that their OneDrive for Business content will be deleted.'
                ExcludedFileExtensions = @(
                    'String | Optional | Exclude files from being synced to OneDrive'
                )
                NotificationsInOneDriveForBusinessEnabled = 'Boolean | Optional | Turn notifications on/off OneDrive'
                OneDriveStorageQuota = 'UInt32 | Optional | The resource quota to apply to the OneDrive sites'
                BlockMacSync = 'Boolean | Optional | Block sync client on Mac'
                OneDriveForGuestsEnabled = 'Boolean | Optional | Enable guest acess for OneDrive'
                DomainGuids = @(
                    'String | Optional | Safe domain list'
                )
            }
        }
        Planner = @{
            Plans = @(
                @{
                    Title = 'String | Required | The Title of the Planner Plan.'
                    Ensure = 'String | Optional | Present ensures the Plan exists, absent ensures it is removed | Present / Absent'
                    UniqueId = 'String | Required | Unique ID to identify this specific object'
                    OwnerGroup = 'String | Required | Name of Id of the Azure Active Directory Group who owns the plan'
                }
            )
        }
        PowerPlatform = @{
            TenantSettings = @{
                DisableShareWithEveryone = 'Boolean | Optional | When set to true this will disable the ability to share apps with the whole tenant.'
                DisableCommunitySearch = 'Boolean | Optional | When set to true this will disable community search in the Office 365 Suite navigation bar.'
                WalkMeOptOut = 'Boolean | Optional | When set to true this will disable the Walk Me guidance.'
                ShareWithColleaguesUserLimit = 'UInt32 | Optional | The amount of people an app can be shared with in Dataverse for Teams (maximum is 10,000).'
                DisableCapacityAllocationByEnvironmentAdmins = 'Boolean | Optional | When set to true this will disable capacity allocation by environment admins.'
                DisableNewsletterSendout = 'Boolean | Optional | When set to true this will disable the monthly newsletters.'
                DisableDocsSearch = 'Boolean | Optional | When set to true this will disable docs search in the Office 365 Suite navigation bar.'
                DisableEnvironmentCreationByNonAdminUsers = 'Boolean | Optional | When set to true this will disable production environment creation by non-admin users.'
                DisableSupportTicketsVisibleByAllUsers = 'Boolean | Optional | When set to true this will disable support tickets to be visible by all users.'
                DisablePortalsCreationByNonAdminUsers = 'Boolean | Optional | When set to true this will disable portal creation by non-admin users.'
                EnableGuestsToMake = 'Boolean | Optional | When set to true this will enable the ability for guests in your tenant to create Power Platform resources.'
                DisableTrialEnvironmentCreationByNonAdminUsers = 'Boolean | Optional | When set to true this will disable trial environment creation by non-admin users.'
                DisableSurveyFeedback = 'Boolean | Optional | When set to true this will disable survey feedback that sometimes pops up on top of an app.'
                DisableNPSCommentsReachout = 'Boolean | Optional | When set to true this will disable the NPS Comments Reachout.'
                DisableBingVideoSearch = 'Boolean | Optional | When set to true this will disable Bing video search in the Office 365 Suite navigation bar.'
            }
        }
        SecurityCompliance = @{
            AuditConfigurationPolicies = @(
                @{
                    Ensure = 'String | Optional | Specify if this policy should exist or not. | Present / Absent'
                    UniqueId = 'String | Required | Unique ID to identify this specific object'
                    Workload = 'String | Required | Workload associated with the policy. | Exchange / SharePoint / OneDriveForBusiness'
                }
            )
        }
        SharePoint = @{
            TenantSettings = @{
                UsePersistentCookiesForExplorerView = 'Boolean | Optional | Lets SharePoint issue a special cookie that will allow this feature to work even when Keep Me Signed In is not selected.'
                CommentsOnSitePagesDisabled = 'Boolean | Optional | Set to false to enable a comment section on all site pages, users who have access to the pages can leave comments. Set to true to disable this feature.'
                ApplyAppEnforcedRestrictionsToAdHocRecipients = 'Boolean | Optional | '
                PublicCdnEnabled = 'Boolean | Optional | Configure PublicCDN'
                DisabledWebPartIds = 'String | Optional | Provide GUID for the Web Parts that are to be disabled on the Sharepoint Site'
                PublicCdnAllowedFileTypes = 'String | Optional | Configure filetypes allowed for PublicCDN'
                FilePickerExternalImageSearchEnabled = 'Boolean | Optional | '
                MaxCompatibilityLevel = 'UInt32 | Optional | Specifies the upper bound on the compatibility level for new sites.'
                Ensure = 'String | Optional | Only accepted value is ''Present''. | Present / Absent'
                HideSyncButtonOnTeamSite = 'Boolean | Optional | To enable or disable Sync button on Team sites'
                UserVoiceForFeedbackEnabled = 'Boolean | Optional | Allow feedback via UserVoice.'
                OwnerAnonymousNotification = 'Boolean | Optional | '
                HideDefaultThemes = 'Boolean | Optional | Defines if the default themes are visible or hidden'
                ConditionalAccessPolicy = 'String | Optional | Allow or Block Conditional Access Policy on the SharePoint Tenant | AllowFullAccess / AllowLimitedAccess / BlockAccess'
                SignInAccelerationDomain = 'String | Optional | Specifies the home realm discovery value to be sent to Azure Active Directory (AAD) during the user sign-in process.'
                SearchResolveExactEmailOrUPN = 'Boolean | Optional | Removes the search capability from People Picker. Note, recently resolved names will still appear in the list until browser cache is cleared or expired.'
                UseFindPeopleInPeoplePicker = 'Boolean | Optional | When set to $true, users aren''t able to share with security groups or SharePoint groups'
                NotificationsInSharePointEnabled = 'Boolean | Optional | When set to $true, users aren''t able to share with security groups or SharePoint groups'
                MinCompatibilityLevel = 'UInt32 | Optional | Specifies the lower bound on the compatibility level for new sites.'
                LegacyAuthProtocolsEnabled = 'Boolean | Optional | Setting this parameter prevents Office clients using non-modern authentication protocols from accessing SharePoint Online resources.'
                OfficeClientADALDisabled = 'Boolean | Optional | When set to true this will disable the ability to use Modern Authentication that leverages ADAL across the tenant.'
                MarkNewFilesSensitiveByDefault = 'String | Optional | Allow or block external sharing until at least one Office DLP policy scans the content of the file. | AllowExternalSharing / BlockExternalSharing'
            }
        }
        Teams = @{
            ClientConfiguration = @{
                AllowEmailIntoChannel = 'Boolean | Optional | When set to $true, mail hooks are enabled, and users can post messages to a channel by sending an email to the email address of Teams channel.'
                AllowShareFile = 'Boolean | Optional | Designates whether users are able to leverage ShareFile as a third party storage solution in Microsoft Teams. If $true, users will be able to add ShareFile in the client and interact with the files stored there.'
                ResourceAccountContentAccess = 'String | Optional | Require a secondary form of authentication to access meeting content. | NoAccess / PartialAccess / FullAccess'
                AllowBox = 'Boolean | Optional | Designates whether users are able to leverage Box as a third party storage solution in Microsoft Teams. If $true, users will be able to add Box in the client and interact with the files stored there.'
                ContentPin = 'String | Optional | This setting applies only to Skype for Business Online (not Microsoft Teams) and defines whether the user must provide a secondary form of authentication to access the meeting content from a resource device account. Meeting content is defined as files that are shared to the Content Bin - files that have been attached to the meeting. | NotRequired / RequiredOutsideScheduleMeeting / AlwaysRequired'
                AllowSkypeBusinessInterop = 'Boolean | Optional | When set to $true, Teams conversations automatically show up in Skype for Business for users that aren''t enabled for Teams.'
                AllowOrganizationTab = 'Boolean | Optional | When set to $true, users will be able to see the organizational chart icon other users'' contact cards, and when clicked, this icon will display the detailed organizational chart.'
                RestrictedSenderList = @(
                    'String | Optional | Senders domains can be further restricted to ensure that only allowed SMTP domains can send emails to the Teams channels. This is a comma-separated string of the domains you''d like to allow to send emails to Teams channels.'
                )
                AllowResourceAccountSendMessage = 'Boolean | Optional | Surface Hub uses a device account to provide email and collaboration services (IM, video, voice). This device account is used as the originating identity (the from party) when sending email, IM, and placing calls. As this account is not coming from an individual, identifiable user, it is deemed anonymous because it originated from the Surface Hub''s device account. If set to $true, these device accounts will be able to send chat messages in Skype for Business Online (does not apply to Microsoft Teams).'
                AllowDropBox = 'Boolean | Optional | Designates whether users are able to leverage DropBox as a third party storage solution in Microsoft Teams. If $true, users will be able to add DropBox in the client and interact with the files stored there.'
                AllowEgnyte = 'Boolean | Optional | Designates whether users are able to leverage Egnyte as a third party storage solution in Microsoft Teams. If $true, users will be able to add Egnyte in the client and interact with the files stored there.'
                AllowScopedPeopleSearchandAccess = 'Boolean | Optional | If set to $true, the Exchange address book policy (ABP) will be used to provide customized view of the global address book for each user. This is only a virtual separation and not a legal separation.'
                AllowGoogleDrive = 'Boolean | Optional | Designates whether users are able to leverage GoogleDrive as a third party storage solution in Microsoft Teams. If $true, users will be able to add Google Drive in the client and interact with the files stored there.'
                AllowGuestUser = 'Boolean | Optional | Designates whether or not guest users in your organization will have access to the Teams client. If $true, guests in your tenant will be able to access the Teams client. Note that this setting has a core dependency on Guest Access being enabled in your Office 365 tenant.'
            }
        }
    }
}
