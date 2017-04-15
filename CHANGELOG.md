##[Release 0.4]
- Update runner from v9.0.0 to 9.0.1
##[Release 0.3]
- gitlab-runner updated from v1.11.1 to v9.0.0 which is required if you're using GitLab 9.x or later in order to be able to use the GitLab API v4
- Note: Next release will probably stop compiling the dumb-init binary within the image build process because it ends up being a heavy image (about 90 MB compressed) against being pre-compiled (about 45 MB compressed) and the main idea is to have an image as lightweight as possible.
##[Realease 0.2]
- dumb-init binary (v1.2.0) built within the image build process.
## [Release 0.1]
- Includes:
    - dumb-init binary (v1.2.0) was built on Raspberry Pi 3 model B running HypriotOS.
    - gitlab-runner v1.11.1.
- The image is intended to run on arm (32bit) devices (for now), but has only been tested on the Raspberry Pi 3 Model B.
