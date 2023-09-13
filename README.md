<div align="center">
	<p>
	<img alt="Thoughtworks Logo" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/thoughtworks_flamingo_wave.png?sanitize=true" width=200 /><br />
	<img alt="DPS Title" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/EMPCPlatformStarterKitsImage.png?sanitize=true" width=350/><br />
	<h2>psk-platform-global-env-values</h2>
	<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/github/license/ThoughtWorks-DPS/psk-platform-global-env-values"></a> <a href="https://aws.amazon.com"><img src="https://img.shields.io/badge/-deployed-blank.svg?style=social&logo=amazon"></a>
	</p>
</div>

As an engineering platform scales, certain environment settings take on the attributes of a globally shared value. In a sense, one can see this immediately in the case of service account credentials. These are created and stored in a generally available secrets store rather than duplicated in the multiple places where needed. Other settings that can easily be managed within a single domain pipeline are better accessed from a generally available key/value store as more of the platform becomes dynamic in scale.  

An example of such scale occurs when the definition of `Production` expands to include multiple active regions.  

Example:  

Assume an engineering platform in AWS supports the following regions `us-east-1, us-west-2, eu-central-1, eu-west-1, ap-east-1, ap-southeast-2`. In such a case, deploying an EKS upgrade will mean managing a version upgrade to six EKS clusters not just one. And typically some or all of such clusters concurrently.  

The control-plane-deployment collects these cluster instances within named groups so that release pipelines can be structured to dynamically push changes based on the values within this global config rather than being a hard-coded attribute of the pipeline.  

So continuing with the example of six regions, the control-plane-deployment value could look like this:  
```json
{
    "sandbox": {
        "sbx-dev": [
            "sbx-dev-i01-aws-us-east-1",
            "sbx-dev-i01-aws-eu-west-1"
        ],
        "sbx-qa": [
            "sbx-qa-i01-aws-us-east-1",
            "sbx-qa-i01-aws-eu-west-1"
        ],
        "sbx-mapi": [
            "sbx-mapi-i01-aws-us-east-1"
        ]
    },
    "platform": {
        "preview": [
            "preview-i01-aws-us-east-1",
            "preview-i01-aws-us-west-2",
            "preview-i01-aws-eu-central-1",
            "preview-i01-aws-eu-west-1",
            "preview-i01-ap-east-1",
            "preview-i01-ap-southeast-2",
            "mapi-i01-aws-us-east-2",
            "mapi-i01-aws-eu-west-3"
        ],
        "nonprod": [
            "nonprod-i01-aws-us-east-1",
            "nonprod-i01-aws-us-west-2",
            "nonprod-i01-aws-eu-central-1",
            "nonprod-i01-aws-eu-west-1",
            "nonprod-i01-ap-east-1",
            "nonprod-i01-ap-southeast-2"
        ],
        "prod": [
            "prod-i01-aws-us-east-1",
            "prod-i01-aws-us-west-2",
            "prod-i01-aws-eu-central-1",
            "prod-i01-aws-eu-west-1",
            "prod-i01-ap-east-1",
            "prod-i01-ap-southeast-2"
        ]
    }
}
```

Where you have access from the start to a SaaS-based, secure k/v store (such as 1password used by this Platform Starter Kit example) such a service can readily serve for both secure and non-secure values.  

Recall from the PSK foundational principles, _the desired state of the platform must be a known quantity_ therefore this global-env-values repository serves as the location where such global values are managed and the associated pipeline need only sync changes into the global accessible k/v store.  

Note: these are not secrets. The source of truth for the desired value is this git repository, and even if the repository is Private these key/value pairs should not contain secure or confidential information.  

### development

The psk lab uses a single, global_values.json file that contains all global key/value settings. The pipeline parses this json and updates the respective values within 1password empc-labs vault.  

The integration test compares the stored values to the desired values and also runs nightly. If the value were manually changed (such as through the 1password app or webui) this will cause the nightly job to fail.  

The `requirements.txt` file only exist to support pre-commit.  

See the [notes](notes.md) for additional details for each global value.  
