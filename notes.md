<div align="center">
	<p>
	<img alt="Thoughtworks Logo" src="https://raw.githubusercontent.com/twplatformlabs/static/master/thoughtworks_flamingo_wave.png?sanitize=true" width=200 /><br />
	<img alt="DPS Title" src="https://raw.githubusercontent.com/twplatformlabs/static/master/EMPCPlatformStarterKitsImage.png?sanitize=true" width=350/><br />
	<h2>psk-platform-global-env-values</h2>
	<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/github/license/twplatformlabs/psk-platform-global-env-values"></a> <a href="https://aws.amazon.com"><img src="https://img.shields.io/badge/-deployed-blank.svg?style=social&logo=amazon"></a>
	</p>
</div>

### Notes for global_values.json elements

#### control-plane-deployent

The EMPC lab only has two instances. Use of a global_value for dynamic deployments is not warranted but included in one or two places just for demonstration purposes.

```json
{
    "psk-platform-global-env-values": {

        "control-plane-deployment": {
            "sandbox": {                        # sandbox pipeline
                "filter": "*on-push-main",      # git push as trigger
                "deploy": [
                    "sbxdev"                    # deploy only sbxdev role
                ],
                "roles": {
                    "sbxdev": {
                        "deploy": [
                            "sbx-i01-aws-us-east-1"        # sbxdev has only 1 instance
                        ],
                        "instances": {
                            "sbx-i01-aws-us-east-1": {
                                "aws_region": "us-east-1",
                                "aws_account_id": "090950721693"
                            }
                        }
                    }
                }
            },
            "release": {                        # release pipeline
                "filter": "*on-tag-main",       # git tag as trigger
                "deploy": [
                    "prod"                      # deploy only the prod role
                ], 
                "roles": {
                    "prod": {            
                        "deploy": [
                            "prod-i01-aws-us-east-2"   # prod has only 1 instance
                        ],
                        "instances": {
                            "prod-i01-aws-us-east-2": {
                                "aws_region": "us-east-2",
                                "aws_account_id": "481538974648"
                            }
                        }
                    }
                }
            }
        }
    }```