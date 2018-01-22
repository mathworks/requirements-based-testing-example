function success = disableModelCoverage(model)

set_param(model, 'CovHtmlReporting', 'off')
set_param(model, 'CovMetricSettings', 'dcme')
set_param(model, 'CovModelRefEnable', 'off')

success = 1;
