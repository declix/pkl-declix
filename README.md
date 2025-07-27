
# Pkl Declix

Declarative Linux system configuration using [Pkl](https://pkl-lang.org/).

This package provides Pkl modules for managing Linux system resources including files, directories, packages, users, groups, and systemd services with type safety and validation.

## Features

- **File & Directory Management** (`fs/`) - Create, modify, and manage files and directories with proper ownership and permissions
- **Package Management** (`apt/`, `dpkg/`) - Install and remove packages via APT and dpkg
- **User & Group Management** (`user/`) - Create and manage system users and groups with passwd/group file fields
- **Systemd Services** (`systemd/`) - Manage systemd units, services, and their states
- **Type Safety** - Full Pkl type checking and validation
- **Missing State Support** - Declarative removal of resources using `Missing` state

## Installation

For installation instructions and usage examples, see the **[latest release notes](https://github.com/declix/pkl-declix/releases/latest)**.

Quick start - Add to your `PklProject`:

```pkl
dependencies {
    ["pkl-declix"] {
        uri = "package://pkl.declix.org/pkl-declix@X.Y.Z"
    }
}
```

## Usage Examples

### User Management

```pkl
import "@pkl-declix/user/user.pkl"

resources = new Listing {
    // Create a system service user
    new user.User {
        name = "webapp"
        state = new user.UserPresent {
            uid = 1001
            gid = 1001
            comment = "Web Application User"
            home = "/var/lib/webapp"
            shell = "/usr/sbin/nologin"
        }
    }
    
    // Create a group
    new user.Group {
        name = "webusers"
        state = new user.GroupPresent {
            gid = 1001
            members = new Listing { "webapp", "admin" }
        }
    }
    
    // Remove a user
    new user.User {
        name = "olduser"
        state = new user.Missing {}
    }
}
```

### File Management

```pkl
import "@pkl-declix/fs/fs.pkl"

resources = new Listing {
    new fs.File {
        path = "/etc/myapp/config.conf"
        state = new fs.FilePresent {
            content = "server_port=8080\ndebug=false"
            owner = "root"
            group = "root"
            permissions = "644"
        }
    }
    
    new fs.Dir {
        path = "/var/lib/myapp"
        state = new fs.DirPresent {
            owner = "webapp"
            group = "webapp"
            permissions = "755"
        }
    }
}
```

### Package Management

```pkl
import "@pkl-declix/apt/apt.pkl"

resources = new Listing {
    ...apt.install(new Listing { "nginx", "postgresql", "redis-server" })
}
```

### Systemd Services

```pkl
import "@pkl-declix/systemd/systemd.pkl"

resources = new Listing {
    new systemd.Unit {
        name = "myapp.service"
        state = new systemd.Enabled {
            active = true
            autoStart = true
        }
    }
}
```

## Module Reference

- **`apt/`** - APT package management
- **`dpkg/`** - Direct dpkg package management  
- **`fs/`** - File and directory management
- **`systemd/`** - Systemd unit management
- **`user/`** - User and group management

## Development

Follow https://www.conventionalcommits.org/en/v1.0.0/

### Testing

```bash
# Run module tests
pkl test

# Test specific module
cd user && pkl test
```