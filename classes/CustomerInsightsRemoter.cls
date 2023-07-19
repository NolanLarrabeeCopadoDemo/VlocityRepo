global with sharing class CustomerInsightsRemoter {

    global CustomerInsightsRemoter() {
    } // empty constructor

    @RemoteAction
    global static Map<string, object> dataOk() {
        boolean errorFlag = false;
        Integer accountCount = 0;
        Integer userCount = 0;
        Integer opportunityCount = 0;
        List<string> errorMessages = new List<string>();


        // Validate the following for these objects 1) Integration user has access 2) at least 1 record exists
        List<String> objectsToValidate = new list<String>{
                'Account',
                'User',
                'Opportunity'
        };

        try {
            for (String objectToValidate : objectsToValidate) {
                //Check for a access to Integration User
                if (!(boolean) wavetemplate.Access.integUserHasAccessToSObjectField(objectToValidate, 'Id')) {
                    errorMessages.add('The Analytics Integration User Profile does not have access to the ' + objectToValidate + ' Object.');
                    errorFlag = true;

                    // No need to try and do count if Analytics Integration user doesn't have access to object so continue
                    continue;
                }
                // Checking for presence of records in the objects
                if (doesRecordExist(objectToValidate) == 0) {
                    errorMessages.add('Customer Insights requires at least one record in the ' + objectToValidate + ' Object');
                    errorFlag = true;
                }
            }
        }

        catch (Exception e) {
            //really big orgs may fail on this query - incase they do let's assume they have accounts,opportunities,users
            accountCount = 1;
            userCount = 1;
            opportunityCount = 1;
        }

        // return the result
        if (errorFlag) {
            // return the error message
            return new Map<String, Object>{
                    'success' => false,
                    'messages' => errorMessages,
                    'errorMessages' => errorMessages
            };
        }

        return new Map<String, Object>{
                'success' => true,
                'messages' => new List<String>{
                        'Your org meets the minimum requirements for creating the app.'
                }
        };
    }

    private static Integer doesRecordExist(String objectName) {
        try {
            return database.countQuery('SELECT count() FROM ' + objectName + ' LIMIT 1');
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return 0;
    }

    private static List<List<String>> getInitialMessages2d() {
        return new List<List<String>>{
                new List<String>(),
                new List<String>()
        };
    }

    private static Map<String, Object> hasActivities() {
      boolean errorFlag = false;
      List<string> errorMessages = new List<string>();
      List<Object> variableSettings = new List<Object>();
      List<List<String>> messages2d = getInitialMessages2d();
      // where to put the message: 0 - has, 1 - doesn't have
      Integer msgIndex = 0;
      try {
        Schema.SObjectType events = Schema.getGlobalDescribe().get('Event');
        Schema.SobjectType tasks = Schema.getGlobalDescribe().get('Task');
        if (events != null && tasks != null) {
            string eventsQuery = 'SELECT count() FROM Event LIMIT 1';
            string tasksQuery = 'SELECT count() FROM Task LIMIT 1';
            Integer eventsCount = database.countQuery(eventsQuery);
            Integer tasksCount = database.countQuery(tasksQuery);

            if (!(boolean) wavetemplate.Access.integUserHasAccessToSObjectField('Event', 'Id')) {
                errorMessages.add('The Analytics Integration User Profile does not have access to the Event Object.');
                errorFlag = true;
            }
            else if (!(boolean) wavetemplate.Access.integUserHasAccessToSObjectField('Task', 'Id')) {
                errorMessages.add('The Analytics Integration User Profile does not have access to the Task Object.');
                errorFlag = true;
            }
            else if (eventsCount > 0 && tasksCount > 0) {
                variableSettings.add(new Map<string, object>{
                        'name' => 'Has_Activities',
                        'value' => 'Yes'
                });
            }
            else {
                msgIndex = 1;
                variableSettings.add(new Map<string, object>{
                        'name' => 'Has_Activities',
                        'value' => 'No'
                });
            }
        }
        else {
            msgIndex = 1;
            variableSettings.add(new Map<string, object>{
                    'name' => 'Has_Activities',
                    'value' => 'No'
            });
        }
      }
      catch (Exception e) {
          System.debug('Something went wrong, no activities:' + e);
      }

      messages2d[msgIndex].add('Event and Task');
      return new Map<String, Object>{
              'success' => true,
              'variableSettings' => variableSettings,
              'messages2d' => messages2d
      };
    }

    public static Map<String, Object> hasUserRoles() {
      List<string> errorMessages = new List<string>();
      List<Object> variableSettings = new List<Object>();
      List<List<String>> messages2d = getInitialMessages2d();
      // where to put the message: 0 - has, 1 - doesn't have
      Integer msgIndex = 0;
      try {
        Schema.SObjectType userRole = Schema.getGlobalDescribe().get('UserRole');
        Schema.SObjectType user = Schema.getGlobalDescribe().get('User');
        if (userRole != null && user != null) {
            string queryUserRoles = 'SELECT count() FROM User WHERE userrole.parentRoleID != null';
            Integer userRoleCount = database.countQuery(queryUserRoles);

            if (userRoleCount > 0) {
                variableSettings.add(new Map<string, object>{
                        'name' => 'Has_UserRoles',
                        'value' => 'Yes'
                });
            }
            else {
                msgIndex = 1;
                variableSettings.add(new Map<string, object>{
                        'name' => 'Has_UserRoles',
                        'value' => 'No'
                });
                errorMessages.add('No UserRoles present');
            }
        }
        else {
                msgIndex = 1;
                variableSettings.add(new Map<string, object>{
                        'name' => 'Has_UserRoles',
                        'value' => 'No'
                });
                errorMessages.add('No access to UserRole object');
        }
      } catch (Exception e) {
        System.debug('Something went wrong, no user roles:' + e);
      }

      if(errorMessages.size() == 0) {
          messages2d[msgIndex].add('User Roles');
          return new Map<String, Object> {
              'success' =>true,'variableSettings' =>variableSettings, 'messages2d' =>messages2d
          };
      } else {
          return new Map<String, Object>{ 'success' => false, 'messages' => errorMessages, 'errorMessages' => errorMessages };
      }
    }

    private static Map<String, Object> hasProducts() {
      boolean errorFlag = false;
      List<string> errorMessages = new List<string>();
      List<Object> variableSettings = new List<Object>();
      List<List<String>> messages2d = getInitialMessages2d();
      // where to put the message: 0 - has, 1 - doesn't have
      Integer msgIndex = 0;
      try {
        Schema.SObjectType products = Schema.getGlobalDescribe().get('Product2');
        if (products != null) {
            string queryLineItems = 'SELECT count() FROM OpportunityLineItem WHERE Product2Id != null AND PricebookEntryId != null LIMIT 1000';
            Integer countLineItems = database.countQuery(queryLineItems);

            if (countLineItems > 0) {
                variableSettings.add(new Map<string, object>{
                        'name' => 'Has_Products',
                        'value' => 'Yes'
                });
            }
            else {
                msgIndex = 1;
                variableSettings.add(new Map<string, object>{
                        'name' => 'Has_Products',
                        'value' => 'No'
                });
            }
        }
        else {
                msgIndex = 1;
                variableSettings.add(new Map<string, object>{
                        'name' => 'Has_Products',
                        'value' => 'No'
                });
        }
      }
      catch (Exception e) {
        System.debug('Something went wrong, no products:' + e);
      }

      messages2d[msgIndex].add('Opportunity Line Items');
      return new Map<String, Object>{
              'success' => true,
              'variableSettings' => variableSettings,
              'messages2d' => messages2d
      };
    }

    public static Map<String, Object> hasDataSyncEnabled() {
        boolean isSuccess = true;
        List<string> errorMessages = new List<string>();
        List<Object> variableSettings = new List<Object>();
        List<List<String>> messages2d = getInitialMessages2d();

        try {
            // boolean orgHasReplicationEnabled = java:wave.template.extension.TemplateApexUtils.isDataSyncOrDirectDigestEnabled();

            // When using BPO based templates, we can't call internal java classes so
            // manually set orgHasReplicationEnabled = true

             boolean orgHasReplicationEnabled = true;

            System.debug('orgHasReplicationEnabled value is set to: ' + orgHasReplicationEnabled);
            if (orgHasReplicationEnabled) {
                messages2d[0].add('Data Sync is enabled');
                variableSettings.add(new Map<string, object>{
                        'name' => 'Has_DataSyncEnabled',
                        'value' => 'Yes'
                });
            } else {
                isSuccess = false;
                messages2d[0].add('Data Sync is not enabled. Please enable Data Sync or enable recipes to use direct data to continue.');
                variableSettings.add(new Map<string, object>{
                        'name' => 'Has_DataSyncEnabled',
                        'value' => 'No'
                });
            }
        }
        catch (Exception e) {
            System.debug('Something went wrong, data sync is not enabled:' + e);
            isSuccess = false;
            messages2d[0].add('Data Sync is not enabled. Please enable Data Sync or enable recipes to use direct data to continue.');
            variableSettings.add(new Map<string, object>{
                    'name' => 'Has_DataSyncEnabled',
                    'value' => 'No'
            });
        }

        // This calls the REST API which is pretty horrible round-trip call to make and probably not even allowed in all customer orgs:
        //
        // String orgUrl = URL.getOrgDomainUrl().toExternalForm();
        // String restUrl = orgUrl + '/services/data/v55.0/wave/replicatedDatasets';
        // Http http = new Http();
        // HttpRequest request = new HttpRequest();
        // request.setMethod('GET');
        // request.setEndpoint(restUrl);
        // request.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        // request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        // try {
        //     // If TCRM Data Sync Org Pref is enabled, this should return 200 OK, else it will return a 403 Forbidden
        //     HttpResponse response = http.send(request);
        //     if (response.getStatusCode() == 200) {
        //         messages2d[0].add('Data Sync is enabled');
        //         variableSettings.add(new Map<string, object>{
        //                 'name' => 'Has_DataSyncEnabled',
        //                 'value' => 'Yes'
        //         });
        //     }
        //     else {
        //         isSuccess = false;
        //         messages2d[0].add('Data Sync is not enabled.  Please enable data sync to continue.');
        //         variableSettings.add(new Map<string, object>{
        //                 'name' => 'Has_DataSyncEnabled',
        //                 'value' => 'No'
        //         });
        //     }
        // }
        // catch (Exception e) {
        //     System.debug('Something went wrong, data sync is not enabled:' + e);
        //     isSuccess = false;
        //     messages2d[0].add('Data Sync is not enabled.  Please enable data sync to continue.');
        //     variableSettings.add(new Map<string, object>{
        //             'name' => 'Has_DataSyncEnabled',
        //             'value' => 'No'
        //     });
        // }

        return new Map<String, Object>{
                'success' => isSuccess,
                'variableSettings' => variableSettings,
                'messages2d' => messages2d,
                'errorMessages' => errorMessages
        };
    }

    public static Map<String, Object> hasRoleHierarchy() {
      List<Object> variableSettings = new List<Object>();
      String message;
      try {
        Integer RoleCount = 0;

        //Check for users with roles that have role parents
        RoleCount = Database.countQuery('SELECT count() FROM User WHERE userrole.parentRoleID != null');

        if (RoleCount > 0) {
          //Customer is using role hierarchy, so let's use it!!
          variableSettings.add(new Map<string, object>{
                  'name' => 'Has_RoleHierarchy',
                  'value' => 'Yes'
          });
          message = 'CRM Analytics has detected that this org uses Role Hierarchy.';
        } else {
          variableSettings.add(new Map<string, object>{
                  'name' => 'Has_RoleHierarchy',
                  'value' => 'No'
          });
          message = 'CRM Analytics has detected that this org doesn\'t use Role Hierarchy.';
        }
      }
      catch (Exception e) {
        // fallback do nothing
      }
      return new Map<String, Object>{
              'success' => true,
              'variableSettings' => variableSettings,
              'messages' => new List<String>{message}
      };
    }

    public static Map<String, Object> hasCases() {
        List<List<String>> messages2d = getInitialMessages2d();
        Integer msgIndex = 0;
        List<Object> variableSettings = new List<Object>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Case');
        if (targetType != null) {
            try {
                    variableSettings.add(new Map<string, object>{
                            'name' => 'Has_Cases',
                            'value' => 'Yes'
                    });
                }
            catch (Exception e) {
                System.debug('Something went wrong, no cases:' + e);
            }
        } else {
            msgIndex = 1;
            variableSettings.add(new Map<string, object>{
                            'name' => 'Has_Cases',
                            'value' => 'No'
            });
        }
        messages2d[msgIndex].add('Cases');
        return new Map<String, Object>{
                'success' => true,
                'variableSettings' => variableSettings,
                'messages2d' => messages2d
        };
    }

    public static Map<String, Object> hasLeads() {
        List<List<String>> messages2d = getInitialMessages2d();
        Integer msgIndex = 0;
        List<Object> variableSettings = new List<Object>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Lead');
        if (targetType != null) {
            try {
                Integer count = Database.countQuery('Select count() from Lead where ConvertedOpportunityId != null limit 1');
                if (count < 1) {
                    msgIndex = 1;
                    variableSettings.add(new Map<string, object>{
                            'name' => 'Has_Leads',
                            'value' => 'No'
                    });
                } else {
                    variableSettings.add(new Map<string, object>{
                            'name' => 'Has_Leads',
                            'value' => 'Yes'
                    });
                }
            }
            catch (Exception e) {
                System.debug('Something went wrong, no leads:' + e);
            }
        } else {
            msgIndex = 1;
            variableSettings.add(new Map<string, object>{
                            'name' => 'Has_Leads',
                            'value' => 'No'
            });
        }
        messages2d[msgIndex].add('Leads');
        return new Map<String, Object>{
                'success' => true,
                'variableSettings' => variableSettings,
                'messages2d' => messages2d
        };
    }

    public static Map<String, Object> hasPersonAccount() {
        List<List<String>> messages2d = getInitialMessages2d();
        Integer msgIndex = 0;
        boolean isPersonAccount = false;
        List<Object> variableSettings = new List<Object>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Account');
        if (targetType != null) {
            try {
                isPersonAccount = Schema.sObjectType.Account.fields.getMap().containsKey('IsPersonAccount');
                if (!isPersonAccount) {
                    messages2d[0].add('PersonAccount is not enabled');
                    variableSettings.add(new Map<string, object>{
                            'name' => 'Has_PersonAccount',
                            'value' => 'No'
                    });
                } else {
                    messages2d[msgIndex].add('PersonAccount is enabled');
                    variableSettings.add(new Map<string, object>{
                            'name' => 'Has_PersonAccount',
                            'value' => 'Yes'
                    });
                }
            }
            catch (Exception e) {
                messages2d[0].add('PersonAccount is not enabled');
                System.debug('Something went wrong determining if PersonAccount is enabled or not:' + e);
            }
        } else {
            messages2d[0].add('PersonAccount is not enabled');
            variableSettings.add(new Map<string, object>{
                            'name' => 'Has_PersonAccount',
                            'value' => 'No'
            });
        }

        return new Map<String, Object>{
                'success' => true,
                'variableSettings' => variableSettings,
                'messages2d' => messages2d
        };
    }


    /*****2.Method to Autoscan and set fiscal******/
    private static Map<String, Object> setFiscal() {
        List<Object> variableSettings = new List<Object>();
        String offset;
        try {
            Integer months = [
                    SELECT
                            FiscalYearStartMonth
                    FROM
                            Organization
            ].FiscalYearStartMonth;

            Map<Integer, string> a = new Map<Integer, string>{
                    1 => '01 - January',
                    2 => '02 - February',
                    3 => '03 - March',
                    4 => '04 - April',
                    5 => '05 - May',
                    6 => '06 - June',
                    7 => '07 - July',
                    8 => '08 - August',
                    9 => '09 - September',
                    10 => '10 - October',
                    11 => '11 - November',
                    12 => '12 - December'
            };
            String monthOffset = a.get(months);
            system.debug('monthOffset is ' + monthOffset);
            variableSettings.add(new Map<string, object>{
                    'name' => 'Fiscal_Month',
                    'value' => monthOffset
            });
            offset = monthOffset;
            // set description? No.
            // template.getVariables().get('Fiscal_Month').setDescription('Wave has selected the month based on your Salesforce settings but you may override this value.');
        } catch (Exception e) {
            //just in case
            variableSettings.add(new Map<string, object>{
                    'name' => 'Fiscal_Month',
                    'value' => '01 - January'
            });
            offset = '01 - January';
        }
        return new Map<String, Object>{
                'success' => true,
                'variableSettings' => variableSettings,
                'messages' => new List<String>{
                        'Fiscal month is set to ' + offset.substring(5) + ', '
                }
        };
    }

    /**
    * Private method to initialize the Locale Mapping
    * @returns Map<String, Integer>
    */
    private static Map<String, Integer> initLocaleMap() {
        //add all mappings for Supported Locales and their Start Day offset here
        Map<String, Integer> mymap = new Map<String, Integer>();
        mymap.put('sq_AL', 6);
        mymap.put('ar_DZ', 6);
        mymap.put('ar_BH', 6);
        mymap.put('ar_EG', 0);
        mymap.put('ar_IQ', 0);
        mymap.put('ar_JO', 6);
        mymap.put('ar_KW', 6);
        mymap.put('ar_LB', 6);
        mymap.put('ar_LY', 6);
        mymap.put('ar_MA', 6);
        mymap.put('ar_OM', 6);
        mymap.put('ar_QA', 6);
        mymap.put('ar_SA', 6);
        mymap.put('ar_SD', 6);
        mymap.put('ar_SY', 6);
        mymap.put('ar_TN', 6);
        mymap.put('ar_AE', 6);
        mymap.put('ar_YE', 6);
        mymap.put('hy_AM', 0);
        mymap.put('az_AZ', 0);
        mymap.put('eu_ES', 0);
        mymap.put('be_BY', 0);
        mymap.put('bn_BD', 0);
        mymap.put('bs_BA', 0);
        mymap.put('bg_BG', 0);
        mymap.put('my_MM', 0);
        mymap.put('ca_ES_EURO', 1);
        mymap.put('ca_ES', 1);
        mymap.put('zh_CN_PINYIN', 0);
        mymap.put('zh_CN_STROKE', 0);
        mymap.put('zh_CN', 0);
        mymap.put('zh_HK_STROKE', 0);
        mymap.put('zh_HK', 0);
        mymap.put('zh_MO', 0);
        mymap.put('zh_SG', 0);
        mymap.put('zh_TW_STROKE', 0);
        mymap.put('zh_TW', 0);
        mymap.put('hr_HR', 1);
        mymap.put('cs_CZ', 1);
        mymap.put('da_DK', 1);
        mymap.put('nl_AW', 1);
        mymap.put('nl_BE', 1);
        mymap.put('nl_NL', 1);
        mymap.put('nl_SR', 1);
        mymap.put('dz_BT', 0);
        mymap.put('en_AG', 0);
        mymap.put('en_AU', 0);
        mymap.put('en_BS', 0);
        mymap.put('en_BB', 0);
        mymap.put('en_BZ', 0);
        mymap.put('en_BM', 0);
        mymap.put('en_BW', 0);
        mymap.put('en_CM', 0);
        mymap.put('en_CA', 0);
        mymap.put('en_KY', 0);
        mymap.put('en_ER', 0);
        mymap.put('en_FK', 0);
        mymap.put('en_FJ', 0);
        mymap.put('en_GM', 0);
        mymap.put('en_GH', 0);
        mymap.put('en_GI', 0);
        mymap.put('en_GY', 0);
        mymap.put('en_HK', 0);
        mymap.put('en_IN', 0);
        mymap.put('en_ID', 0);
        mymap.put('en_IE_EURO', 1);
        mymap.put('en_IE', 1);
        mymap.put('en_JM', 0);
        mymap.put('en_KE', 0);
        mymap.put('en_LR', 0);
        mymap.put('en_MG', 0);
        mymap.put('en_MW', 0);
        mymap.put('en_MY', 0);
        mymap.put('en_MU', 0);
        mymap.put('en_NA', 0);
        mymap.put('en_NZ', 0);
        mymap.put('en_NG', 0);
        mymap.put('en_PK', 0);
        mymap.put('en_PG', 0);
        mymap.put('en_PH', 0);
        mymap.put('en_RW', 0);
        mymap.put('en_SH', 0);
        mymap.put('en_WS', 0);
        mymap.put('en_SC', 0);
        mymap.put('en_SL', 0);
        mymap.put('en_SG', 0);
        mymap.put('en_SX', 0);
        mymap.put('en_SB', 0);
        mymap.put('en_ZA', 0);
        mymap.put('en_SZ', 0);
        mymap.put('en_TZ', 0);
        mymap.put('en_TO', 0);
        mymap.put('en_TT', 0);
        mymap.put('en_UG', 0);
        mymap.put('en_GB', 1);
        mymap.put('en_US', 0);
        mymap.put('en_VU', 0);
        mymap.put('et_EE', 1);
        mymap.put('fi_FI_EURO', 1);
        mymap.put('fi_FI', 1);
        mymap.put('fr_BE', 1);
        mymap.put('fr_CA', 0);
        mymap.put('fr_KM', 1);
        mymap.put('fr_FR_EURO', 1);
        mymap.put('fr_FR', 1);
        mymap.put('fr_GN', 1);
        mymap.put('fr_HT', 1);
        mymap.put('fr_LU', 1);
        mymap.put('fr_MR', 1);
        mymap.put('fr_MC', 1);
        mymap.put('fr_CH', 1);
        mymap.put('fr_WF', 1);
        mymap.put('ka_GE', 0);
        mymap.put('de_AT_EURO', 1);
        mymap.put('de_AT', 1);
        mymap.put('de_DE_EURO', 1);
        mymap.put('de_DE', 1);
        mymap.put('de_LU_EURO', 1);
        mymap.put('de_LU', 1);
        mymap.put('de_CH', 1);
        mymap.put('el_GR', 1);
        mymap.put('iw_IL', 0);
        mymap.put('hi_IN', 0);
        mymap.put('hu_HU', 1);
        mymap.put('is_IS', 1);
        mymap.put('in_ID', 1);
        mymap.put('ga_IE', 0);
        mymap.put('it_IT', 1);
        mymap.put('it_CH', 1);
        mymap.put('ja_JP', 0);
        mymap.put('kk_KZ', 0);
        mymap.put('km_KH', 0);
        mymap.put('ky_KG', 0);
        mymap.put('ko_KP', 0);
        mymap.put('ko_KR', 0);
        mymap.put('lo_LA', 0);
        mymap.put('lv_LV', 0);
        mymap.put('lt_LT', 1);
        mymap.put('lu_CD', 0);
        mymap.put('lb_LU', 0);
        mymap.put('mk_MK', 0);
        mymap.put('ms_BN', 0);
        mymap.put('ms_MY', 0);
        mymap.put('mt_MT', 0);
        mymap.put('ne_NP', 0);
        mymap.put('no_NO', 1);
        mymap.put('ps_AF', 0);
        mymap.put('fa_IR', 0);
        mymap.put('pl_PL', 1);
        mymap.put('pt_AO', 1);
        mymap.put('pt_BR', 0);
        mymap.put('pt_CV', 1);
        mymap.put('pt_MZ', 1);
        mymap.put('pt_PT', 1);
        mymap.put('pt_ST', 1);
        mymap.put('ro_MD', 1);
        mymap.put('ro_RO', 1);
        mymap.put('rm_CH', 0);
        mymap.put('rn_BI', 0);
        mymap.put('ru_RU', 1);
        mymap.put('sr_BA', 1);
        mymap.put('sr_RS', 0);
        mymap.put('sr_CS', 1);
        mymap.put('sh_BA', 1);
        mymap.put('sh_ME', 1);
        mymap.put('sh_CS', 1);
        mymap.put('sk_SK', 1);
        mymap.put('sl_SI', 1);
        mymap.put('so_DJ', 0);
        mymap.put('so_SO', 0);
        mymap.put('es_AR', 1);
        mymap.put('es_BO', 1);
        mymap.put('es_CL', 1);
        mymap.put('es_CO', 1);
        mymap.put('es_CR', 1);
        mymap.put('es_CU', 1);
        mymap.put('es_DO', 1);
        mymap.put('es_EC', 1);
        mymap.put('es_SV', 1);
        mymap.put('es_GT', 1);
        mymap.put('es_HN', 1);
        mymap.put('es_MX', 1);
        mymap.put('es_NI', 1);
        mymap.put('es_PA', 1);
        mymap.put('es_PY', 1);
        mymap.put('es_PE', 1);
        mymap.put('es_PR', 1);
        mymap.put('es_ES_EURO', 1);
        mymap.put('es_ES', 1);
        mymap.put('es_US', 0);
        mymap.put('es_UY', 1);
        mymap.put('es_VE', 1);
        mymap.put('sv_SE', 1);
        mymap.put('tl_PH', 0);
        mymap.put('tg_TJ', 0);
        mymap.put('ta_IN', 0);
        mymap.put('ta_LK', 0);
        mymap.put('th_TH', 0);
        mymap.put('ti_ET', 0);
        mymap.put('tr_TR', 1);
        mymap.put('uk_UA', 1);
        mymap.put('ur_PK', 0);
        mymap.put('uz_LATN_UZ', 0);
        mymap.put('vi_VN', 0);
        mymap.put('cy_GB', 0);
        mymap.put('yo_BJ', 0);

        return mymap;
    }

    private static Map<String, Object> aggregateResults(List<Map<String, Object>> resultList) {

        Boolean allGood = true;
        List<Map<String, Object>> variableSettings = new List<Map<String, Object>>();
        List<String> messages = new List<String>();
        List<String> errorMessages = new List<String>();
        List<List<String>> messages2d = new List<List<String>>();

        // iterate over the results
        for (Map<String, Object> result : resultList) {
            // if one failed all failed
            if (!((boolean) result.get('success'))) {
                allGood = false;
            }

            // aggregate the variable settings
            if (result.containsKey('variableSettings')) {
                for (Object s : (List<Object>) result.get('variableSettings')) {
                    variableSettings.add((Map<String, Object>) s);
                }
            }

            // and messages
            if (result.containsKey('messages')) {
                List<String> addedMessages = (List<String>) result.get('messages');
                if (result.containsKey('mergeWithPrevious')) {
                    messages[messages.size() - 1] += addedMessages[0];
                } else {
                    messages.addAll(addedMessages);
                }
            }

            // and errorMessages
            //if (result.containsKey('errorMessages')) {
             //   List<String> _messages = (List<String>) result.get('errorMessages');
             //   errorMessages.addAll(errorMessages);
           //}

            // and array of array of messages
            if (result.containsKey('messages2d')) {
                List<Object> resultMessages = (List<Object>) result.get('messages2d');
                // for each array in 2d array
                for (Integer i = 0; i < resultMessages.size(); i++) {
                    // incoming array bigger than what we have
                    if ((i + 1) > messages2d.size()) {
                        messages2d.add(new List<String>());
                    }
                    messages2d[i].addAll((List<String>) resultMessages[i]);
                }
            }
        }

        // flatten the messages2d into messages
        for (Integer i = 0; i < messages2d.size(); i++) {
            List<String> messageList = messages2d[i];
            messages.addAll((List<String>) messageList);
            if (i < messages2d.size() - 1) {
                // space between the lists - not for the last
                messages.add('');
            }
        }

        // aggregate the messages and variable settings
        return new Map<String, Object>{
            'success' => allGood,
            'messages' => messages,
            'errorMessages' => errorMessages,
            'variableSettings' => variableSettings
        };
    }

    /**
    * Private method to get and assign the firstDayOfWeek
    */
    private static Map<String, Object> assignFirstDay() {

        List<Object> variableSettings = new List<Object>();

        //initialize Map with Locales and their Start Days
        Map<String, Integer> localeMap = new Map<String, Integer>();
        localeMap = initLocaleMap();
        Integer firstday;
        String firstdayName;
        List<String> dayNames = new List<String>{
                'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
        };

        //Check if Context User is an Integration User and get their Locale
        String contextUserType = UserInfo.getUserType();

        if (contextUserType == 'Analytics Cloud Integration User') {
            String contextUserLocale = UserInfo.getLocale();
            system.debug('This is the Integration User' + contextUserLocale);
            firstday = localeMap.get(contextUserLocale);
            system.debug(firstday);
        }
        //Else just get the current Organizations Locale
        else {
            Organization org = [SELECT DefaultLocaleSidKey FROM Organization];
            String contextOrgLocale = org.DefaultLocaleSidKey;
            system.debug('This is the Org ' + contextOrgLocale);
            firstday = localeMap.get(contextOrgLocale);
            system.debug(firstday);
        }

        if (firstday != null) {
            //Assign Start Day to First_Day_Of_Week variable in variables.json
            variableSettings.add(new Map<string, object>{
                    'name' => 'First_Day_Of_Week',
                    'value' => firstday
            });
            firstdayName = dayNames[firstday];
        } else {
            //If the locale doesnt exist in the map, then set the variable to 0 by default.
            variableSettings.add(new Map<string, object>{
                    'name' => 'First_Day_Of_Week',
                    'value' => 0
            });
            firstdayName = dayNames[0];
        }

        return new Map<String, Object>{
                'success' => true,
                'variableSettings' => variableSettings,
                'messages' => new List<String>{
                        'first day of week to ' + firstdayName + '. '
                },
                'mergeWithPrevious' => true
        };
    }


    @RemoteAction
    global static Map<string, object> objectUsage() {
      List<Map<String, Object>> resultList = new List<Map<String, Object>>();
      resultList.add( new Map<String, Object>{
            'success' => true,
            'messages2d' => new List<Object> {
              new List<String>{'CRM Analytics has detected that your org has the following:'},
              new List<String> {'CRM Analytics has detected your org does not use the following:'}
            }
          });

      resultList.add(hasActivities());
      resultList.add(hasProducts());
      resultList.add(hasCases());
      resultList.add(hasLeads());

      // aggregate results
      return aggregateResults(resultList);
    }


    @RemoteAction
    global static Map<string, object> fieldAccess() {
        // read it from a variable set in Modifier
        return new Map<String, Object>{
                'success' => true,
                'messagesVariable' => 'DefaultsVisibleMessages'
        };
    }

    @RemoteAction
    global static Map<string, object> configuration() {
        List<Map<String, Object>> resultList = new List<Map<String, Object>>();
        resultList.add(setFiscal());
        resultList.add(assignFirstDay());
        resultList.add(hasDataSyncEnabled());
        resultList.add(hasPersonAccount());

        // aggregate results
        return aggregateResults(resultList);
    }

    @RemoteAction
    global static Map<string, object> dataInconsistencies() {
        return hasRoleHierarchy();

    }

}