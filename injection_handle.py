#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
import os.path
import string
import shutil
from distutils.dir_util import copy_tree

"""
1. 请把该脚本放入组件化git工程根目录使用
2. 参数使用：如果直接运行，不加任何参数，则执行injection程序；如果有参数'push'/'PUSH'，
   则拷贝__pods下的源代码到git控制下的组件代码文件夹
3. python injection_handle.py push
4. python injection_handle.py reset

修改适配其他工程？
唯一需要做的是修改变量'example_path'和'module_source_code_path'
通过标准cocoapod创建的目录结构略有不同
"""


def main():

    current_path = os.getcwd()
    print('当前路径: ' + current_path)

    # 获得主功能模块，这里不考虑*Protocol.podspec
    main_module_name = get_main_module(current_path)
    print('主要功能模块名字:' + main_module_name)

    # Example下包含*.xcodeproj和*.xcworkspace
    example_path = os.path.join(current_path, 'Example')

    # 初始化私有pod文件夹路径
    local_pod_path = init_local_pod_folder(example_path)

    # 组件代码原始所在的路径
    module_source_code_path = os.path.join(current_path, main_module_name)

    # 注入完成组件代码所在工作区
    work_classes_path = os.path.join(local_pod_path, main_module_name)

    args = sys.argv[1:]
    # 拷贝injection工作代码到git 工作区
    if check_will_push(args):
        copy_workSource_to_git(work_classes_path, module_source_code_path)
    # 重置项目，使其不再injection
    elif check_will_rest(args):

        # 修改Podfile组件路径
        pod_file = os.path.join(example_path, 'Podfile')
        print('开始对Podfile进行修改->' + pod_file)
        update_pod_file(pod_file, main_module_name, 2)
        # 执行pod install
        execute_pod_install(example_path)
    else:
        # 集成injection
        confirm_operation()

        # 拷贝文件
        copy_sources(os.path.join(current_path, main_module_name + '.podspec'), local_pod_path)
        copy_sources(module_source_code_path, work_classes_path)
        print('完成源代码拷贝\n')

        # 修改Podfile组件路径
        pod_file = os.path.join(example_path, 'Podfile')
        print('开始对Podfile进行修改->' + pod_file)
        update_pod_file(pod_file, main_module_name)

        # 修改appDelegate文件
        update_appdelegate(os.path.join(example_path, main_module_name, 'HWAppDelegate.m'))

        # 执行pod install
        execute_pod_install(example_path)


def get_main_module(file_path):
    all_files = os.listdir(file_path)
    for file in all_files:

        (name, ext) = os.path.splitext(file)
        if ext == '.podspec' and string.find(file, 'Protocol') == -1:
            return name


def init_local_pod_folder(example_path):
    local_pod = example_path + '/__pods/'
    if os.path.exists(local_pod) is not True:
        print('__pods不存在，创建...')
        os.makedirs(local_pod)
    else:
        backup_local_pod(local_pod)

    return local_pod


def copy_sources(file_or_folder, destination):
    print('拷贝' + file_or_folder)
    print('')

    if not os.path.exists(destination):
        os.makedirs(destination)

    if os.path.isfile(file_or_folder):
        shutil.copy(file_or_folder, destination)
    elif os.path.isdir(file_or_folder):
        if os.path.exists(destination):
            name = raw_input('警告⚠️：在__pods中发现已经存在相应的源文件.\n是否覆盖？该操作不可逆!\n请输入(Y/N)\n')
            if string.lower(name) == 'y' or string.lower(name) == 'yes' or name == '':
                print('开始删除旧的源文件->' + destination)
                shutil.rmtree(destination)
                copy_tree(file_or_folder, destination)
            else:
                print('终止操作！')
                sys.exit()
        else:
            copy_tree(file_or_folder, destination)


def update_pod_file(pod_file, module_name, mode=1):

    if mode == 1:
        print('开始执行注入模式>>>>\n')
    else:
        print('开始执行重置模式>>>>\n')

    file_handler = open(pod_file, 'r')
    content = file_handler.readlines()
    index = -1
    for line in content:
        if string.find(line, 'pod \'' + module_name + '\'') != -1:
            index = content.index(line)
            break

    if index != -1:
        str = content[index]
        print('找到对应组件:' + module_name)
        path_index = str.find('path =>')
        module_start = str.find('\'', path_index) + 1
        module_end = str.find('\'', module_start)
        module_path = str[module_start: module_end]

        if mode == 1:
            str = string.replace(str, module_path, '__pods/')
        else:
            str = string.replace(str, module_path, '../')

        content[index] = str
        print('已完成对podfile修改')
    else:
        print('未找到需要替换的组件，可能已经被替换')

    out = open(pod_file, 'w')
    out.writelines(content)
    file_handler.close()
    out.close()
    print('')


def update_appdelegate(file_path):
    print('开始修改AppDelegate文件...')
    file_handler = open(file_path, 'r')
    content = file_handler.readlines()

    index = -1
    end_index = -1
    for line in content:
        if string.find(line, 'didFinishLaunchingWithOptions') != -1:
            if index == -1:
                index = content.index(line)
        elif string.find(line, 'InjectionIII.app') != -1:
            print('AppDelegate文件先前已修改🤪\n')
            file_handler.close()
            return
        elif string.find(line, 'return') != -1:
            if index != -1:
                end_index = content.index(line)
                break

    injection_code = '''
#if DEBUG
    [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
#endif

    '''
    content.insert(end_index, injection_code)

    out = open(file_path, 'w')
    out.writelines(content)

    file_handler.close()
    out.close()
    print('完成修改AppDelegate文件')


def execute_pod_install(example_path, sourcemode=True):
    has_gem = False
    for item in os.listdir(example_path):
        if item == 'Gemfile':
            print('发现gem文件')
            has_gem = True
            break

    if has_gem:
        os.chdir(example_path)
        if sourcemode:
            os.system('sh pod_source_mode.sh')
        else:
            os.system('sh pod_framework_mode.sh')

    else:
        os.chdir(example_path)
        os.system('pod install')


def backup_local_pod(path):
    backup_path = os.path.join(os.environ['HOME'], '_backPod')
    print('开始备份\n备份__pods至' + backup_path)
    print('')
    copy_tree(path, backup_path)


def confirm_operation():
    name = raw_input('请在执行该脚本前确认⚠️:\n__pod文件夹中的代码已经备份或者拷贝到git source code文件夹中？\n确定？请输入(Y/N)\n')
    if string.lower(name) == 'y' or string.lower(name) == 'yes' or name == '':
        return
    else:
        print('终止操作！')
        sys.exit()


def check_will_push(args):
    for param in args:
        if string.lower(param) == 'push':
            return True
    return False


def check_will_rest(args):
    for param in args:
        if string.lower(param) == 'reset':
            return True
    return False


def copy_workSource_to_git(source, git_path):
    print('拷贝源码至git目录下...')
    print(source + ' ->>>\n' + git_path)
    copy_tree(source, git_path)


if __name__ == '__main__':
    main()
