## Mount an exfat drive

Mount autmoatically

Use `blkid /dev/xxxx` to determine UUID of a partition.
Then add the following line in /etc/fstab, where UUID should **not** be quoted.

```
UUID=XXXX-XXXX  /mnt/media  exfat  defaults,nofail,uid=1000,gid=1000,umask=0022  0  2
```

Mount manually

```
sudo mount -t exfat -o uid=1000,gid=1000,umask=0022 /dev/xxxx /mnt/media
```

## Mount an ext4 drive

Mount autmoatically

Use `blkid /dev/xxxx` to determine UUID of a partition.
Then add the following line in /etc/fstab, where UUID should **not** be quoted.

```
UUID=XXXX-XXXX  /mnt/media  ext4  defaults,nofail,noatime 0  2
```

Mount manually

```
sudo mount -t ext4 /dev/xxxx /mnt/media
```
