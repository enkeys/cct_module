
Feature: Openshift common tests

  @jboss-decisionserver-6 @jboss-processserver-6 @jboss-webserver-3/webserver30-tomcat7-openshift @jboss-webserver-3/webserver31-tomcat7-openshift @jboss-webserver-3/webserver30-tomcat8-openshift @jboss-webserver-3/webserver31-tomcat8-openshift @jboss-amq-6
  Scenario: Check jolokia port is available
    When container is ready
    Then check that port 8778 is open
    Then inspect container
       | path                    | value       |
       | /Config/ExposedPorts    | 8778/tcp    |

  # CLOUD-1017: Option to enable script debugging
  @jboss-kieserver-6 @jboss-decisionserver-6 @jboss-processserver-6 @jboss-webserver-3/webserver30-tomcat7-openshift @jboss-webserver-3/webserver31-tomcat7-openshift @jboss-webserver-3/webserver30-tomcat8-openshift @jboss-webserver-3/webserver31-tomcat8-openshift @jboss-amq-6 @jboss-datavirt-6 @redhat-sso-7
  Scenario: Check that script debugging (set -x) can be enabled
    When container is started with env
       | variable     | value |
       | SCRIPT_DEBUG | true  |
    Then container log should contain + echo 'Script debugging is enabled, allowing bash commands and their arguments to be printed as they are executed'

  # https://issues.jboss.org/browse/CLOUD-912
  @jboss-decisionserver-6 @jboss-processserver-6 @jboss-webserver-3/webserver30-tomcat7-openshift @jboss-webserver-3/webserver31-tomcat7-openshift @jboss-webserver-3/webserver30-tomcat8-openshift @jboss-webserver-3/webserver31-tomcat8-openshift @jboss-amq-6 @jboss-datavirt-6
  Scenario: Check that java binaries are linked properly
    When container is ready
    Then run sh -c 'test -L /usr/bin/java && echo "yes" || echo "no"' in container and immediately check its output for yes
     And run sh -c 'test -L /usr/bin/keytool && echo "yes" || echo "no"' in container and immediately check its output for yes
     And run sh -c 'test -L /usr/bin/rmid && echo "yes" || echo "no"' in container and immediately check its output for yes
     And run sh -c 'test -L /usr/bin/javac && echo "yes" || echo "no"' in container and immediately check its output for yes
     And run sh -c 'test -L /usr/bin/jar && echo "yes" || echo "no"' in container and immediately check its output for yes
     And run sh -c 'test -L /usr/bin/rmic && echo "yes" || echo "no"' in container and immediately check its output for yes
     And run sh -c 'test -L /usr/bin/xjc && echo "yes" || echo "no"' in container and immediately check its output for yes
     And run sh -c 'test -L /usr/bin/wsimport && echo "yes" || echo "no"' in container and immediately check its output for yes

  @jboss-kieserver-6
  Scenario: CLOUD-892, Container should fail if the KIE_SERVER_USER is not created
    When container is started with env
      | variable 	 	| value                      |
      | KIE_SERVER_USER 	| openshift                  |
      | KIE_SERVER_PASSWORD 	| weakpwd                    |
    Then container log should contain Password must have at least 8 characters!
    And container log should contain Failed to create the user openshift
    And container log should contain Exiting...

  @jboss-decisionserver-6 @jboss-processserver-6 @jboss-webserver-3/webserver30-tomcat7-openshift @jboss-webserver-3/webserver31-tomcat7-openshift @jboss-webserver-3/webserver30-tomcat8-openshift @jboss-webserver-3/webserver31-tomcat8-openshift @rhdm-7/rhdm71-controller-openshift @rhdm-7/rhdm71-decisioncentral-openshift @rhdm-7/rhdm71-kieserver-openshift @rhpam-7/rhpam71-businesscentral-openshift @rhpam-7/rhpam71-businesscentral-monitoring-openshift @rhpam-7/rhpam71-controller-openshift @rhpam-7/rhpam71-kieserver-openshift
  Scenario: Enable Access Log
    When container is started with env
      | variable          | value            |
      | ENABLE_ACCESS_LOG | true             |
    Then container log should contain Configuring Access Log Valve.

  @jboss-decisionserver-6 @jboss-processserver-6 @jboss-webserver-3/webserver30-tomcat7-openshift @jboss-webserver-3/webserver31-tomcat7-openshift @jboss-webserver-3/webserver30-tomcat8-openshift @jboss-webserver-3/webserver31-tomcat8-openshift @rhdm-7/rhdm71-controller-openshift @rhdm-7/rhdm71-decisioncentral-openshift @rhdm-7/rhdm71-kieserver-openshift @rhpam-7/rhpam71-businesscentral-openshift @rhpam-7/rhpam71-businesscentral-monitoring-openshift @rhpam-7/rhpam71-controller-openshift @rhpam-7/rhpam71-kieserver-openshift
  Scenario: Test Default Access Log behavior
    When container is ready
    Then container log should not contain Configuring Access Log Valve.
    And container log should contain Access log is disabled, ignoring configuration.
