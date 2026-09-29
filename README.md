# dotfiles

macOS 个人开发环境配置，zsh 为主 shell，通过符号链接接入 `$HOME`，并统一管理 agent skills。

## 前置依赖

### [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

### [Homebrew](https://brew.sh/)

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 快速开始

```sh
make all      # 装工具(Brewfile) + 装 nvm + 装 skills(Skillsfile) + 链接
```

也可以分步执行：

| 命令 | 作用 |
|---|---|
| `make brew` | 通过 [Brewfile](./Brewfile) 安装命令行工具 |
| `make nvm` | 安装 nvm（Node 版本管理器） |
| `make skill` | 通过 [Skillsfile](./Skillsfile) 安装 agent skills |
| `make link` | 幂等符号链接 dotfiles 到 `$HOME`（等价 `./link.sh`） |
| `make help` | 列出全部目标 |

## 目录结构

```text
zsh/              zsh 专属：zshrc 入口、aliases
shell/            共享层：env / aliases / functions
git/              gitconfig、全局 gitignore
Brewfile          命令行工具清单（make brew）
Skillsfile        agent skills 清单（make skill）
install_nvm.sh    nvm 安装器
install_skills.sh Skillsfile 安装器
```

入口文件会解析自身符号链接定位仓库根目录，再 source `shell/` 下的共享配置，环境变量、alias、函数集中单点维护。

### 链接映射

| 仓库文件 | $HOME 链接 |
|---|---|
| zsh/zshrc | ~/.zshrc |
| git/gitconfig | ~/.gitconfig |
| git/gitignore_global | ~/.gitignore_global |

## 快捷命令

Git 高频命令通过 [gitconfig](./git/gitconfig) 的 alias 提供（`git <命令>`），与 oh-my-zsh git 插件互补：

| 命令 | 作用 |
|---|---|
| `git st` | 精简单行状态 |
| `git sync` | 拉取最新，rebase + 自动暂存本地改动 |
| `git amend` | 补进上一次提交（不改动提交信息） |
| `git unstage` | 撤销暂存 |
| `git wip` / `git unwip` | 一键存档 / 还原存档 |
| `git last` | 查看最后一次提交改动的文件 |
| `git lg` | 图形化短格式日志 |
| `git recent` | 按最近活跃列出本地分支 |
| `git purge` | 删除已合并的本地分支（保护 master/main）并 prune 远端 |

Shell 侧：`la`/`ll`（列目录）、`pj`（JSON 格式化）、`cw <dir>`（进入 workspace 子目录）、`rl`（重载 shell）。

## Node 版本管理

Node 由 nvm 管理（`make nvm` 安装到 `~/.nvm`，shell 启动时自动加载），不使用 Homebrew 的 node。

```sh
nvm install --lts       # 安装最新 LTS
nvm install 20          # 安装指定大版本
nvm use 20              # 切换版本
nvm alias default 20    # 设置默认版本
```

## Agent Skills

skills 由 [Skillsfile](./Skillsfile) 声明式管理，安装器 [install_skills.sh](./install_skills.sh) 按清单浅克隆来源仓库、取出对应子目录，落地为 `~/.agents/skills/<name>` 下的真实目录（非软链）。

- **新增 skill**：在 Skillsfile 加一行（名称、仓库、子目录），执行 `make skill`。
- **更新 skill**：删掉 `~/.agents/skills/<name>` 后重新 `make skill`，即可拉取上游最新版。
- **锁定版本**：在该行末尾加第 4 列（commit/tag/branch）即可固定到指定版本。
- **移除 skill**：从 Skillsfile 删除该行，并手动 `rm -rf ~/.agents/skills/<name>`。
- 已安装的 skill 会跳过；安装器会自动清理旧方案遗留的同名软链，但不会覆盖非软链的真实目录。

已声明：

| Skill | 作用 | 来源 |
|---|---|---|
| lieflat-less-ai-tone | 按白名单规则识别并改写成稿中的 AI 写作痕迹（去 AI 味） | [writing-dna-skill](https://github.com/larashero3-dotcom/writing-dna-skill)（latest） |

## 私有配置

机器私有变量（token、密钥等）放入 `~/.secrets`，shell 启动时自动 source，该文件不入库。
