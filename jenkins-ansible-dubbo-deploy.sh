#/bin/sh

host=10.1.11.113
service_dir=/opt/service
service_name=zcckj-tireinfo-service
target_dir=zcckj-tireinfo-service

if [ ! -f d.json ]; then
	echo -e "{\"service_dir\":\"$service_dir\",\"service_name\":\"$service_name\",\"target_dir\":\"$target_dir\"}" | tee d.json
fi
# 如果不存在的话自动创建目录
ansible ${host} -m file  -a 'path={{service_dir}} state=directory' --extra-vars '@d.json';
# 创建用户
#ansible ${host} -m user -a 'name=dubbo system=yes createhome=false shell=/sbin/nologin state=present';
# 拷贝构建
ansible ${host} -m copy  -a 'src={{target_dir}}/target/{{service_name}}.tar.gz dest={{service_dir}}/{{service_name}}.tar.gz owner=root group=root mode=0755' --extra-vars '@d.json';
# 停止之前跑的服务
ansible ${host} -m shell -a './bin/stop.sh || echo "ignore(if not exists)..." chdir={{service_dir}}/{{service_name}}'  --extra-vars '@d.json';
# 删除原先的服务目录
ansible ${host} -m shell -a 'rm -rf {{service_dir}}/{{service_name}} || echo "ignore..."' --extra-vars '@d.json';
# 解压并运行服务
ansible ${host} -m shell -a 'tar -xzvf {{service_name}}.tar.gz && cd {{service_name}} && source /etc/profile && ./bin/start.sh chdir={{service_dir}}' --extra-vars '@d.json';
# 删除压缩包
ansible ${host} -m shell -a 'rm -rf {{service_name}}.tar.gz chdir={{service_dir}}' --extra-vars '@d.json';