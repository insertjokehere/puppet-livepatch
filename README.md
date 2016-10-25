## puppet-livepatch

**Work in progress - may break everything**

Manages the Canonical Livepatch kernel hotpatching service

* Installs the canonical-livepatch snap
* If `$ensure` is set to `enabled`, enables Livepatch on this machine
* If `$ensure` is set to `disabled`, ensure Livepatch is disabled
