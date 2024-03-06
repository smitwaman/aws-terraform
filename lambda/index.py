import boto3
import logging
logger = logging.getLogger(name=__name__)
def lambda_handler(event, context):
    Instance_Id = event["detail"]["EC2InstanceId"]  # get Instance ID from Event
    zone_id = "Z08547268UVSC26AUUJD"      # Hosted Zone ID
    dnsname = 'www.devopsrealtime.com'    #Prepare kafka DNS Record  Name
    #ex: www.devopsrealtime.com
    
    if event["detail-type"] == "EC2 Instance Launch Successful":    #Check for Auto Scaling launch 
        logger.info("Instance launched: %s", Instance_Id)
        route53_client = boto3.client("route53")
        ec2_client = boto3.client("ec2")
        instance_details = ec2_client.describe_instances(InstanceIds=[Instance_Id])
        Instance_IP = instance_details['Reservations'][0]['Instances'][0]['PrivateIpAddress']    #Get the Private IP of the Instance
        dns_response = route53_client.change_resource_record_sets(
        HostedZoneId=zone_id,
            ChangeBatch={
                'Comment': 'Update or Create Route53 records for Operatr',
                'Changes': [
                    {
                        'Action': 'UPSERT',
                        'ResourceRecordSet': {
                            'Name': dnsname,
                            'Type': 'A',
                            'TTL': 60,
                            'ResourceRecords': [
                                {
                                    'Value': Instance_IP
                                }
                            ]
                        }
                    }
                ]
            }
        )    
        logger.info("UPSERT A record response: %s", dns_response)