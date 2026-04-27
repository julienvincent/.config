# Restic Backups

This is my home-rolled automatic restic backup system for Lunos. It's just a collection of scripts wrapping restic which
backup some pre-defined paths to a restic repo described by **[auth.sh](./auth.sh)**.

## Repo Location

The repo is configured at `https://restic.julienvincent.io/lunos` which is just a restic rest-server running in my home
lab. The password is read on-demand from 1Password (requiring user approval to access).

# Include/Exclude Paths

The set of system paths to include or exclude from the backup can be configured in **[config/paths](./config/paths)**
and **[config/exclude](./config/exclude)** respectively.

## Setup

### Scripts

The scripts can be run as-is from this directory, but to make life a bit easier you can symlink them to somewhere on
your PATH:

```bash
ln -s $(pwd)/backup.sh $HOME/.local/bin/lunos-backup
ln -s $(pwd)/prune.sh $HOME/.local/bin/lunos-backup-prune
ln -s $(pwd)/auth.sh $HOME/.local/bin/lunos-backup-auth
```

### SystemD Services

There is systemd timer unit described here which simply prompts you every hour (and only once daily) to perform a
backup.

This is done by sending a DBus notification to backup, with an on-click handler to perform the backup if the
notification is clicked.

You can see the **[./reminder.sh](./reminder.sh)** script for how this works.

To setup this timer you do the following:

```bash
ln -s $(pwd)/systemd/backup-reminder.service $HOME/.config/systemd/user/backup-reminder.service
ln -s $(pwd)/systemd/backup-reminder.timer $HOME/.config/systemd/user/backup-reminder.timer

systemctl --user daemon-reload
systemctl --user enable --now backup-reminder.timer
```

## Manual Usage

You can run backups manually by running

```bash
lunos-backup

# Any arguments to `restic backup` can be passed here
lunos-backup --dry-run
```

You can prune old snapshots by running

```bash
lunos-backup-prune

# Any arguments to `restic forget` can be passed here
lunos-backup-prune --dry-run
```

And finally if you want to manually interact with the restic repo you can pre-auth yourself with

```bash
lunos-backup-auth

# Now all restic commands will be pointed at the repo and be authed
restic snapshots
```
