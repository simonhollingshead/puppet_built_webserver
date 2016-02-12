class zsh {
    class { 'ohmyzsh': }
    ohmyzsh::install { 'simon': }
    ohmyzsh::upgrade { 'simon': }
    ohmyzsh::theme { 'simon': theme => 'ys' }
    ohmyzsh::plugins { 'simon': plugins => 'command-not-found common-aliases compleat cpanm debian git gitfast git-extras git-flow history pip python screne sprunge sudo' }
}