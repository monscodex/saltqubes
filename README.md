# Salt qubes

Salt Formulas for Qubes OS in the spirit of empowerment and simplicity.

QubesOS is a powerful "security by isolation" operating system. Here we use Saltstack (powerful "infrastructure as code" software) to leverage Qubes complexity.

Abstract and automate _some_ of your qubes system complexity. Save time and organize yourself.

## Warning

Qubes development involves high-security procedures to distribute code. It is safe to assume this repo has none.

This is NOT production code. It is a detailed whiteboard that must be modified to your needs.

I do not hold responsible for any vulnerabilities neither in the code nor in its distribution.

## Installing

### Ideal installation

1. Create a disposable
2. Clone the repo
3. Turn off the internet for that qube
4. Review the code.
5. Manually type all code to dom0 or inspire yourself to create your own formula.

### Practical installation (requires git installed on dom0 and files passed to dom0)

#### Clone, review and bundle

1. Install git on dom0 with `qubes-dom0-update git`
2. Create a disposable
3. Clone the repo
4. Turn off the internet for that qube
5. Review the code.
6. Git bundle (from the disposable: cd into the repo and run `git bundle create YOURPATHTOBUNDLE`)

#### Proceed to the installation from dom0

7. Pass the bundle to dom0 (from dom0: `qvm-run --pass-io YOURDISPNAME 'cat YOURFULLPATHTOBUNDLE' > YOURDOM0BUNDLE`)
8. Enable user salt with `qubesctl state.sls qubes.user-dirs`
9. Unbundle with (from dom0: `git clone YOURPATHTODOM0BUNDLE`)
10. Run 00_fix_salt.sh as root (to fix a weird bug in qubes salt 4.2)
11. Copy the code to /srv/user_salt
12. Installed! See the usage section

## Usage (in dom0)

### dom0

1. Add your xfce4 configuration to 'dotfiles/xfce4'
2. Enable dom0 top file with `qubesctl top.enable dom0`
3. Run `qubesctl --show-output state.highstate`
4. Disable the top file `qubesctl top.disable dom0`

### template formulas

1. Enable the corresponding top file
2. Run highstate
3. Disable

### appvm-formulas

1. Read the corresponding sls file
2. It will specify the usage with `# USAGE ...`
3. Edit the sls file to suit your needs
4. Enable top file
5. Run highstate
6. Disable

## Hacking

Automating a big part of qubes with salt was a wild ride.

I am no salt expert, merely a guy with a tiny bit of programming knowledge that happens to love administrating linux systems.

Here are some considerations:

### Set GOALS and CONDITIONS BEFORE starting to code

Salt is beautiful, exciting and _addictive_.

Define WHAT you are trying to automate and set your limits.

My examples:

- [x] Automate templates for _all my needs_
- [x] Automate _a bit_ of tedious appvm config (nix, nix packages for dev setup)
- [x] Using a minimal template _if I can_

Minimal templates are tricky, especially for networking: an area where I lack basic knowledge.

I spent +4 days trying to install protonvpn on a minimal template for `template-protonvpn`. It worked one of debian or fedora but not for the other.

### Keep It Stupid Simple (when you can)

#### Example 1: File organization

All templates have the same file structure.

`common-templates` may seem difficult but it becomes pretty straight forward when you get review it once.

#### Example 2: Jinja

That's the reason saltstack developers use yaml + jinja2 for simple things and python for more complex things.

The whole code is straight forward. I believe `common-appvms/macros.jinja` is on the edge of what's reasonable with jinja.

#### Example 3: See the big picture

You might want to automate every little aspect of a setup. In order to do that, you scripted 90% of the functionality in 2h. Then you realized to achieve the additional 10% it will require a major rewrite of the states you've written, maybe achievable in 4h. Value your time (and your patience)

### Think outside the box

If salt may be unusual to you and things might not work as you expect. In case that happens, be prepared to search for workarounds.

### Example: Grains not working

Grains did not working on qubes 4.2

I wanted to set a grain each time I installed an application (ex: web browser, text editor, etc). Then I would read them to set the default applications for the qube (mimeapps.list).

I instead use a simple solution: verify if the .desktop file exists in the qube. If it exists the app is installed => set it as default application.

## Credits

Special thanks to Ben Grande with their [qusal repository](https://github.com/ben-grande/qusal). They built an impressive, very complex system.

Special thanks to Drkhsh with their [salt-n-pepper repository](https://github.com/drkhsh/salt-n-pepper). They gave me the idea for the layout of the files.
