# devops-marathon-hello

Demo static site for the [devops-marathon](https://github.com/barisMarathon/devops-marathon-infra) platform, live at **https://hello.devopsdelisi.fun**.

It exists to exercise the full delivery pipeline:

```
git push (this repo)
  └─ GitHub Actions
       ├─ docker build  →  ghcr.io/barismarathon/devops-marathon-hello:sha-<commit>
       └─ bump newTag in devops-marathon-gitops/manifests/hello/kustomization.yaml
             └─ Argo CD syncs  →  k3s rolls out the new image
```

The build version is stamped into the page footer, so every deploy is visible in the browser.

## Pipeline details

- **Pull requests** build the image but don't push or deploy.
- **main** builds, pushes `sha-<7 chars>` + `latest`, then commits the new tag to the gitops repo.
- Images are tagged by commit SHA, so every deploy maps to an exact commit and rollbacks are a `git revert` in the gitops repo.
- The gitops repo is written with a **deploy key** scoped to that single repo (`GITOPS_DEPLOY_KEY` secret), not a personal token.
- Deploys are serialized with a `concurrency` group so two pushes never race on the gitops commit.

## Local run

```bash
docker build -t hello --build-arg VERSION=local .
docker run --rm -p 8080:8080 hello   # http://localhost:8080
```
