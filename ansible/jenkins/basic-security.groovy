#!groovy

import jenkins.model.*
import hudson.util.*;
import jenkins.install.*;
import hudson.security.*

// Get current Jenkins instance
def instance = Jenkins.getInstance()

// Get authorization strategy
def strategy = new hudson.security.FullControlOnceLoggedInAuthorizationStrategy()

// Disable anonymoues read/write access
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)
instance.save()

// Mark Jenkins setup as completed
instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)

