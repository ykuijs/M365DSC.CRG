@{
    AllNodes = @(
        @{
            NodeName = 'localhost'
            CertificateFile = '.\DSCCertificate.cer'
        }
    )
    NonNodeData = @{
        Environment = @{
            OrganizationName = '[Name of your organization, e.g. Test]'
            TenantId = '[Tenant URL, e.g. test.onmicrosoft.com]'
            Name = '[Name of your environment, e.g. Test]'
            ShortName = '[Abbreviation of the environment name, e.g. TST]'
        }
        AppCredentials = @(
            @{
                ApplicationId = '878459e4-79e4-4f9a-83d6-738c32ddd5c2'
                Workload = 'AzureAD'
                CertThumbprint = '65E427769F27CDA198231B2A7FF03940897FB687'
            }
            @{
                ApplicationId = '878459e4-79e4-4f9a-83d6-738c32ddd5c2'
                Workload = 'Exchange'
                CertThumbprint = '65E427769F27CDA198231B2A7FF03940897FB687'
            }
            @{
                ApplicationId = '878459e4-79e4-4f9a-83d6-738c32ddd5c2'
                Workload = 'Intune'
                CertThumbprint = '65E427769F27CDA198231B2A7FF03940897FB687'
            }
            @{
                ApplicationId = '878459e4-79e4-4f9a-83d6-738c32ddd5c2'
                Workload = 'Office365'
                CertThumbprint = '65E427769F27CDA198231B2A7FF03940897FB687'
            }
            @{
                ApplicationId = '878459e4-79e4-4f9a-83d6-738c32ddd5c2'
                Workload = 'OneDrive'
                CertThumbprint = '65E427769F27CDA198231B2A7FF03940897FB687'
            }
            @{
                ApplicationId = '878459e4-79e4-4f9a-83d6-738c32ddd5c2'
                Workload = 'Planner'
                CertThumbprint = '65E427769F27CDA198231B2A7FF03940897FB687'
            }
            @{
                ApplicationId = '878459e4-79e4-4f9a-83d6-738c32ddd5c2'
                Workload = 'PowerPlatform'
                CertThumbprint = '65E427769F27CDA198231B2A7FF03940897FB687'
            }
            @{
                ApplicationId = '878459e4-79e4-4f9a-83d6-738c32ddd5c2'
                Workload = 'SecurityCompliance'
                CertThumbprint = '65E427769F27CDA198231B2A7FF03940897FB687'
            }
            @{
                ApplicationId = '878459e4-79e4-4f9a-83d6-738c32ddd5c2'
                Workload = 'SharePoint'
                CertThumbprint = '65E427769F27CDA198231B2A7FF03940897FB687'
            }
            @{
                ApplicationId = '878459e4-79e4-4f9a-83d6-738c32ddd5c2'
                Workload = 'Teams'
                CertThumbprint = '65E427769F27CDA198231B2A7FF03940897FB687'
            }
        )
        AzureAD = @{
            Applications = @(
                @{
                    Owners = 'StringArray | Optional'
                    DisplayName = 'String | Required'
                    Permissions = @(
                        @{
                            AdminConsentGranted = 'Boolean | Optional'
                            Type = 'String | Optional | AppOnly / Delegated'
                            Name = 'String | Optional'
                            UniqueId = 'String | Required | [Unique ID to identify this specific object]'
                            SourceAPI = 'String | Optional'
                        }
                    )
                    UniqueId = 'String | Required | [Unique ID to identify this specific object]'
                    AppId = 'String | Optional'
                    PublicClient = 'Boolean | Optional'
                    KnownClientApplications = 'StringArray | Optional'
                    Ensure = 'String | Optional | Present / Absent'
                    AvailableToOtherTenants = 'Boolean | Optional'
                    IdentifierUris = 'StringArray | Optional'
                    GroupMembershipClaims = 'String | Optional'
                    ObjectId = 'String | Optional'
                    LogoutURL = 'String | Optional'
                    Homepage = 'String | Optional'
                    ReplyURLs = 'StringArray | Optional'
                }
            )
        }
        Exchange = @{
            AcceptedDomains = @(
                @{
                    MatchSubDomains = 'Boolean | Optional'
                    OutboundOnly = 'Boolean | Optional'
                    DomainType = 'String | Optional | Authoritative / InternalRelay'
                    Ensure = 'String | Optional | Present / Absent'
                    Identity = 'String | Required'
                }
            )
        }
        Intune = @{
            AntivirusPoliciesWindows10SettingCatalog = @(
                @{
                    signatureupdatefallbackorder = 'StringArray | Optional'
                    engineupdateschannel = 'String | Optional | 0 / 2 / 3 / 4 / 5 / 6'
                    disableaccountprotectionui = 'String | Optional | 0 / 1'
                    severethreats = 'String | Optional | clean / quarantine / remove / allow / userdefined / block'
                    disabletpmfirmwareupdatewarning = 'String | Optional | 0 / 1'
                    cloudextendedtimeout = 'SInt32 | Optional'
                    signatureupdatefilesharessources = 'StringArray | Optional'
                    daystoretaincleanedmalware = 'SInt32 | Optional'
                    disablecatchupfullscan = 'String | Optional | 0 / 1'
                    schedulequickscantime = 'SInt32 | Optional'
                    disablehealthui = 'String | Optional | 0 / 1'
                    allowscanningnetworkfiles = 'String | Optional | 0 / 1'
                    allowioavprotection = 'String | Optional | 0 / 1'
                    url = 'String | Optional'
                    disablefamilyui = 'String | Optional | 0 / 1'
                    submitsamplesconsent = 'String | Optional | 0 / 1 / 2 / 3'
                    securityintelligenceupdateschannel = 'String | Optional | 0 / 4 / 5'
                    disablelocaladminmerge = 'String | Optional | 0 / 1'
                    excludedextensions = 'StringArray | Optional'
                    enablelowcpupriority = 'String | Optional | 0 / 1'
                    templateId = 'String | Optional | d948ff9b-99cb-4ee0-8012-1fbc09685377_1 / e3f74c5a-a6de-411d-aef6-eb15628f3a0a_1 / 45fea5e9-280d-4da1-9792-fb5736da0ca9_1 / 804339ad-1553-4478-a742-138fb5807418_1'
                    allowuseruiaccess = 'String | Optional | 0 / 1'
                    allowrealtimemonitoring = 'String | Optional | 0 / 1'
                    enableinappcustomization = 'String | Optional | 0 / 1'
                    email = 'String | Optional'
                    moderateseveritythreats = 'String | Optional | clean / quarantine / remove / allow / userdefined / block'
                    companyname = 'String | Optional'
                    hideransomwaredatarecovery = 'String | Optional | 0 / 1'
                    schedulescantime = 'SInt32 | Optional'
                    Description = 'String | Optional'
                    disablenetworkui = 'String | Optional | 0 / 1'
                    allowfullscanonmappednetworkdrives = 'String | Optional | 0 / 1'
                    checkforsignaturesbeforerunningscan = 'String | Optional | 0 / 1'
                    Ensure = 'String | Optional | Present / Absent'
                    signatureupdateinterval = 'SInt32 | Optional'
                    phone = 'String | Optional'
                    DisplayName = 'String | Required'
                    disabledevicesecurityui = 'String | Optional | 0 / 1'
                    tamperprotection = 'String | Optional | 0 / 1'
                    puaprotection = 'String | Optional | 0 / 1 / 2'
                    highseveritythreats = 'String | Optional | clean / quarantine / remove / allow / userdefined / block'
                    allowemailscanning = 'String | Optional | 0 / 1'
                    cloudblocklevel = 'String | Optional | 0 / 2 / 4 / 6'
                    disablecatchupquickscan = 'String | Optional | 0 / 1'
                    allowfullscanremovabledrivescanning = 'String | Optional | 0 / 1'
                    enablecustomizedtoasts = 'String | Optional | 0 / 1'
                    excludedprocesses = 'StringArray | Optional'
                    allowonaccessprotection = 'String | Optional | 0 / 1'
                    hidewindowssecuritynotificationareacontrol = 'String | Optional | 0 / 1'
                    Assignments = @(
                        @{
                            groupId = 'String | Optional'
                            collectionId = 'String | Optional'
                            dataType = 'String | Optional | #microsoft.graph.groupAssignmentTarget / #microsoft.graph.allLicensedUsersAssignmentTarget / #microsoft.graph.allDevicesAssignmentTarget / #microsoft.graph.exclusionGroupAssignmentTarget / #microsoft.graph.configurationManagerCollectionAssignmentTarget'
                            UniqueId = 'String | Required | [Unique ID to identify this specific object]'
                            deviceAndAppManagementAssignmentFilterId = 'String | Optional'
                            deviceAndAppManagementAssignmentFilterType = 'String | Optional | none / include / exclude'
                        }
                    )
                    realtimescandirection = 'String | Optional | 0 / 1 / 2'
                    avgcpuloadfactor = 'SInt32 | Optional'
                    disablecleartpmbutton = 'String | Optional | 0 / 1'
                    disablevirusui = 'String | Optional | 0 / 1'
                    disableenhancednotifications = 'String | Optional | 0 / 1'
                    disableappbrowserui = 'String | Optional | 0 / 1'
                    enablenetworkprotection = 'String | Optional | 0 / 1 / 2'
                    allowintrusionpreventionsystem = 'String | Optional | 0 / 1'
                    allowscriptscanning = 'String | Optional | 0 / 1'
                    excludedpaths = 'StringArray | Optional'
                    lowseveritythreats = 'String | Optional | clean / quarantine / remove / allow / userdefined / block'
                    platformupdateschannel = 'String | Optional | 0 / 2 / 3 / 4 / 5 / 6'
                    schedulescanday = 'String | Optional | 0 / 1 / 2 / 3 / 4 / 5 / 6 / 7 / 8'
                    allowcloudprotection = 'String | Optional | 0 / 1'
                    Identity = 'String | Optional'
                    scanparameter = 'String | Optional | 1 / 2'
                    allowarchivescanning = 'String | Optional | 0 / 1'
                    allowbehaviormonitoring = 'String | Optional | 0 / 1'
                }
            )
        }
        Office365 = @{
            AdminAuditLogConfig = @{
                UniqueId = 'String | Required | [Unique ID to identify this specific object]'
                Ensure = 'String | Optional | Present'
                UnifiedAuditLogIngestionEnabled = 'String | Required | Enabled / Disabled'
            }
        }
        OneDrive = @{
            Settings = @{
                UniqueId = 'String | Required | [Unique ID to identify this specific object]'
                Ensure = 'String | Optional | Present / Absent'
                GrooveBlockOption = 'String | Optional | OptOut / HardOptIn / SoftOptIn'
                ExcludedFileExtensions = 'StringArray | Optional'
                DomainGuids = 'StringArray | Optional'
                TenantRestrictionEnabled = 'Boolean | Optional'
                DisableReportProblemDialog = 'Boolean | Optional'
                BlockMacSync = 'Boolean | Optional'
                ODBAccessRequests = 'String | Optional | On / Off / Unspecified'
                ODBMembersCanShare = 'String | Optional | On / Off / Unspecified'
                NotificationsInOneDriveForBusinessEnabled = 'Boolean | Optional'
                NotifyOwnersWhenInvitationsAccepted = 'Boolean | Optional'
                OneDriveForGuestsEnabled = 'Boolean | Optional'
                OrphanedPersonalSitesRetentionPeriod = 'UInt32 | Optional'
                OneDriveStorageQuota = 'UInt32 | Optional'
            }
        }
        Planner = @{
            Plans = @(
                @{
                    Title = 'String | Required'
                    Ensure = 'String | Optional | Present / Absent'
                    UniqueId = 'String | Required | [Unique ID to identify this specific object]'
                    OwnerGroup = 'String | Required'
                }
            )
        }
        PowerPlatform = @{
            TenantSettings = @{
                UniqueId = 'String | Required | [Unique ID to identify this specific object]'
                ShareWithColleaguesUserLimit = 'UInt32 | Optional'
                EnableGuestsToMake = 'Boolean | Optional'
                DisableShareWithEveryone = 'Boolean | Optional'
                DisableBingVideoSearch = 'Boolean | Optional'
                DisableCommunitySearch = 'Boolean | Optional'
                DisableDocsSearch = 'Boolean | Optional'
                DisableSupportTicketsVisibleByAllUsers = 'Boolean | Optional'
                DisableTrialEnvironmentCreationByNonAdminUsers = 'Boolean | Optional'
                DisableSurveyFeedback = 'Boolean | Optional'
                DisablePortalsCreationByNonAdminUsers = 'Boolean | Optional'
                DisableEnvironmentCreationByNonAdminUsers = 'Boolean | Optional'
                DisableNewsletterSendout = 'Boolean | Optional'
                DisableNPSCommentsReachout = 'Boolean | Optional'
                WalkMeOptOut = 'Boolean | Optional'
                DisableCapacityAllocationByEnvironmentAdmins = 'Boolean | Optional'
            }
        }
        SecurityCompliance = @{
            AuditConfigurationPolicies = @(
                @{
                    UniqueId = 'String | Required | [Unique ID to identify this specific object]'
                    Workload = 'String | Required | Exchange / SharePoint / OneDriveForBusiness'
                    Ensure = 'String | Optional | Present / Absent'
                }
            )
        }
        SharePoint = @{
            TenantSettings = @{
                UniqueId = 'String | Required | [Unique ID to identify this specific object]'
                Ensure = 'String | Optional | Present / Absent'
                CommentsOnSitePagesDisabled = 'Boolean | Optional'
                DisabledWebPartIds = 'String | Optional'
                ConditionalAccessPolicy = 'String | Optional | AllowFullAccess / AllowLimitedAccess / BlockAccess'
                MarkNewFilesSensitiveByDefault = 'String | Optional | AllowExternalSharing / BlockExternalSharing'
                HideSyncButtonOnTeamSite = 'Boolean | Optional'
                HideDefaultThemes = 'Boolean | Optional'
                FilePickerExternalImageSearchEnabled = 'Boolean | Optional'
                ApplyAppEnforcedRestrictionsToAdHocRecipients = 'Boolean | Optional'
                OwnerAnonymousNotification = 'Boolean | Optional'
                NotificationsInSharePointEnabled = 'Boolean | Optional'
                UseFindPeopleInPeoplePicker = 'Boolean | Optional'
                PublicCdnAllowedFileTypes = 'String | Optional'
                PublicCdnEnabled = 'Boolean | Optional'
                UserVoiceForFeedbackEnabled = 'Boolean | Optional'
                UsePersistentCookiesForExplorerView = 'Boolean | Optional'
                SignInAccelerationDomain = 'String | Optional'
                LegacyAuthProtocolsEnabled = 'Boolean | Optional'
                OfficeClientADALDisabled = 'Boolean | Optional'
                SearchResolveExactEmailOrUPN = 'Boolean | Optional'
                MaxCompatibilityLevel = 'UInt32 | Optional'
                MinCompatibilityLevel = 'UInt32 | Optional'
            }
        }
        Teams = @{
            ClientConfiguration = @{
                ContentPin = 'String | Optional | NotRequired / RequiredOutsideScheduleMeeting / AlwaysRequired'
                AllowSkypeBusinessInterop = 'Boolean | Optional'
                ResourceAccountContentAccess = 'String | Optional | NoAccess / PartialAccess / FullAccess'
                AllowShareFile = 'Boolean | Optional'
                AllowScopedPeopleSearchandAccess = 'Boolean | Optional'
                AllowOrganizationTab = 'Boolean | Optional'
                AllowEmailIntoChannel = 'Boolean | Optional'
                AllowGuestUser = 'Boolean | Optional'
                AllowResourceAccountSendMessage = 'Boolean | Optional'
                AllowEgnyte = 'Boolean | Optional'
                AllowDropBox = 'Boolean | Optional'
                AllowGoogleDrive = 'Boolean | Optional'
                AllowBox = 'Boolean | Optional'
                RestrictedSenderList = 'StringArray | Optional'
            }
        }
    }
}
