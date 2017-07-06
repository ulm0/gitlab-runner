## [9.3]
### [Release 9.3.0-UPX]
- Compress the gitlab runner binary using `upx-ucl`

### [Release 9.3.0]

- Runner @ 9.3.0

## [9.2]
### [Release 9.2.2-UPX]
- Compress the gitlab runner binary using `upx-ucl`  with `--best` flag

### [Release 9.2.2]
- Runner @ 9.2.2
### [Release 9.2.1-UPX]
- Compress the gitlab runner binary using `upx-ucl`

### [Release 9.2.1]
- Runner @ 9.2.1

### [Release 9.2.0-UPX]
- Compress the gitlab runner binary using `upx-ucl`

### [Release 9.2.0]

- Runner @ 9.2.0

## [9.1]
### [Release 9.1.3-UPX]

- Compress the gitlab runner binary using `upx-ucl` with `--best` flag

### [Release 9.1.3]

- Runner @ 9.1.3
### [Release 9.1.2-UPX]

- Compress the gitlab runner binary using `upx-ucl`

### [Release 9.1.2]

- Runner @ 9.1.2

### [Release 9.1.1]

#### Tag naming change:
- Tag naming change to adopt [the official tag names](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner/tags).

## [Release 0.9]

- Update runner from 9.1.0 to 9.1.1

## [Release 0.8]

- Update runner from 9.0.3 to 9.1.0

## [Release 0.7]

- Update runner from 9.0.2 to 9.0.3

## [Release 0.6]

- dumb-init compiled in a separate job

## [Release 0.5]

- Update runner from v9.0.1 to 9.0.2

## [Release 0.4]

- Update runner from v9.0.0 to 9.0.1

## [Release 0.3]

- gitlab-runner updated from v1.11.1 to v9.0.0 which is required if you're using GitLab 9.x or later in order to be able to use the GitLab API v4
- Note: Next release will probably stop compiling the dumb-init binary within the image build process because it ends up being a heavy image (about 90 MB compressed) against being pre-compiled (about 45 MB compressed) and the main idea is to have an image as lightweight as possible.

## [Realease 0.2]

- dumb-init binary (v1.2.0) built within the image build process.

## [Release 0.1]

- Includes:
    - dumb-init binary (v1.2.0) was built on Raspberry Pi 3 model B running HypriotOS.
    - gitlab-runner v1.11.1.
- The image is intended to run on arm (32bit) devices (for now), but has only been tested on the Raspberry Pi 3 Model B.