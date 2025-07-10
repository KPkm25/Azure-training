https://calendar.app.google/wBvqqP3jqWRrRYkU7

Step1:  Launch 3 ubuntu instance

       one instance--->controller Machine(CM)

       two instance---->Remote Machine(Host)



Step2: Install Ansible in Controller (CM)



   ssh to controller machine

        >>ssh -i "my.pem" ubuntu@public_ip  Demo in Instance connect

       >> sudo su

      >>apt update -y

Reference:Get  into Ansible document  for instalation on ubuntu

     https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible



$ sudo apt update

$ sudo apt install software-properties-common

$ sudo add-apt-repository --yes --update ppa:ansible/ansible

$apt update    Note:very important

$ sudo apt install ansible



Step3:passwordless authentication  between CM --->RM

In CM

>.sudo su

>> cd /

>>cd  ~/.ssh

>>ssh-keygen  Note two key wud create 1:public key ex(id_ed25519.pub)  2:private key id_ed25519.pub

>>cat id_ed25519.pub

          note :Copy the key

Connect to RM 

>.sudo su



>> cd /

>>cd ~/.ssh

>>vi authorized_keys  

   paste the pub key ie id_ed25519.pub its content  Note :Dont change any exixting key in authroized_keys file just add at top



From CM 

>.sudo su



>> cd /

>>cd ~/.ssh

>>ssh private ip of RM







###############################################################################################

SSH to CM

>>mkdir ansiblepractise



 >>cd ansiblepractise

Create inventory file

>>vi inventory  note: filename can be anything

[webserver]

3.108.65.91   note: public ip address of RM 



Refernce: https://docs.ansible.com/ansible/latest/getting_started/get_started_inventory.html



>>perform adhoc commands to execute or configure various stuff

ref:https://docs.ansible.com/ansible/latest/command_guide/intro_adhoc.html#why-use-ad-hoc-commands

example ping



>>ansible -i inventory webserver -m ping     

                                  --->inventory --file name of the inventory

                                 ----->webserver---webgroup name in the inventory file

                                 ---->-m ping   ---->module ie command ping





>>ansible -i inventory web1 -m apt -a "update_cache=yes" --become   # equivalent to apt update

>>ansible -i inventory web1 -m apt -a "name=apache2 state=present" --become  # equivalent to apt install apache2

>>

ansible -i inventory web1 -m service -a "name=apache2 enabled=yes" --become  # systemctl/service apache2 enabled





uninstall

>>ansible -i inventory webserver -m apt -a "name=apache2 state=absent purge=yes" --become







version1:



---

- name: installation of webservt

 hosts: webserver

 remote_user: root

 vars:

  pg_name: apache2

 tasks:

  - name: update the vm

   apt:

    update_cache: yes

  - name: install apache server

   apt:

    name: "{{pg_name}}"

    state: present      note :present ,absent,latest















Version2 :

---

- name: mywebserver

 hosts: web

 remote_user: root

 become: yes

 vars:

  pak_name: apache2

 tasks:

  - name: Update apt cache

   apt:

    update_cache: yes

  - name: Install Apache

   apt:

    name: "{{ pak_name }}"

    state: latest

  - name: Copy index.html to web root

   copy:

    src: index.html

    dest: /var/www/html/index.html

    owner: www-data

    group: www-data

    mode: '0644'

   notify: Restart Apache

 handlers:

  - name: Restart Apache

   service:

    name: "{{ pak_name }}"

    state: restarted













































    