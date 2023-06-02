<div align="center">
	<p>
	<img alt="Thoughtworks Logo" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/thoughtworks_flamingo_wave.png?sanitize=true" width=200 /><br />
	<img alt="DPS Title" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/EMPCPlatformStarterKitsImage.png?sanitize=true" width=350/><br />
	<h2>psk-platform-global-env-values</h2>
	<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/github/license/ThoughtWorks-DPS/psk-platform-global-env-values"></a> <a href="https://aws.amazon.com"><img src="https://img.shields.io/badge/-deployed-blank.svg?style=social&logo=amazon"></a>
	</p>
</div>

As an engineering platform scales, certain environment settings take on the attributes of a globally shared value. In a sense, one can see this immediately in the case of service account credentials. These are created and stored in a generaly available secrets service rather than duplicated in the multiple places where needed. Other settings that can easily be managed within a single domain pipeline are better accessed from a generally available key/value store as more of the platform becomes dynamic in scale.  

Where you have access from the start to a SaaS-based, secure k/v store (such as 1password used by this Platform Starter Kit example) such a service can readily serve for both secure and non-secure values.  

Recall from the PSK foundational principles, _the desired state of the platform must be a known quantity_ therefore this global-env-values repository serves as the location where such global values are managed and the associated pipeline need only sync changes into the global accessible k/v store.  

### development

There is a single, global_values.json file that contains all of the present global key/value settings. The pipeline parses this json and updates the respective values within 1password in vault=empc-lab, secret=platform-global-config.  

See the [notes](notes.md) for additional details for each global value.  