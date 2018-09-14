# SuperGentoo Overlay

## usage

### with local overlays

```
[SuperGentoo]
location = /usr/local/portage/SuperGentoo
sync-type = git
sync-uri = https://github.com/PaoJiao/SuperGentoo.git
priority=9999
```

### with layman

```sh
layman -o https://raw.github.com/PaoJiao/SuperGentoo/master/repositories.xml -f -a SuperGentoo
```

## packages

- copyq

