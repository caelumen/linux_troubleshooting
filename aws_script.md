# [ AWS ]

https://s3.ap-northeast-2.amazonaws.com/windflex/linux_troubleshooting/putty.exe
https://s3.ap-northeast-2.amazonaws.com/windflex/linux_troubleshooting/puttygen.exe
https://s3.ap-northeast-2.amazonaws.com/windflex/linux_troubleshooting/vmcore
https://s3.ap-northeast-2.amazonaws.com/windflex/linux_troubleshooting/vmlinux



# SSH ������
 - ���� �̰���
 - https://s3.ap-northeast-2.amazonaws.com/windflex/test_key/test_key_share.pem
 - ssh -i test_key_share.pem ec2-user@13.124.162.236




# ���� - default user
 - Amazon Linux 2 �Ǵ� Amazon Linux AMI�� ��� ����� �̸��� ec2-user
 - Centos AMI�� ��� ����� �̸��� centos
 - Debian AMI�� ��� ����� �̸��� admin �Ǵ� root
 - Fedora AMI�� ��� ����� �̸��� ec2-user �Ǵ� fedora
 - RHEL AMI�� ��� ����� �̸��� ec2-user �Ǵ� root
 - SUSE AMI�� ��� ����� �̸��� ec2-user �Ǵ� root
 - Ubuntu AMI�� ��� ����� �̸��� ubuntu


# AWS EC2 => Putty ��� 
 - PuTTYgen�� ����Ͽ� �����̺� Ű ��ȯ
 - ���� Ű�� ��ȯ�Ϸ���,
 - PuTTYgen�� �����մϴ�(��: [Start] �޴����� [All Programs > PuTTY > PuTTYgen] ����).
   Type of key to generate���� RSA�� �����մϴ�.



==============================================
# SSH Key ����
================================================



cd .ssh
sudo vi .ssh/authorized_keys
 -> Ű�� ���� : ssh-rsa [AAAAB===>Ű��==>Mab1] key_name_public

�ߺ����� �Ǿ�����, scp�� ������ ����!!!



# ��Ȯ�� Private-Public Key�� �����Ͽ���, ���� �Ұ�
 - SCP�� �̿��Ͽ�, AWS�� key�� ����
 - ssh -i test_key_share.pem  ec2-user@172.31.18.1
 - ==> unprotected !!!!


# SSH-KEYGEN
 - ssh-keygen -t rsa



