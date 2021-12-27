import React from 'react';
import { Typography } from '@material-ui/core';
import GitHubIcon from '@material-ui/icons/GitHub';
import EmailIcon from '@material-ui/icons/Email';
import LinkedInIcon from '@material-ui/icons/LinkedIn';
import DescriptionIcon from '@material-ui/icons/Description';
import { makeStyles } from '@material-ui/core';
import Grid from '@material-ui/core/Grid';
import Box from '@material-ui/core/Box';

const useStyles = makeStyles({
  icon: {
    minWidth: '35px',
  },
});

const Footer = () => {
  const classes = useStyles();
  return (
    <Box mt={4}>
      <Typography
        variant='body2'
        color='textSecondary'
        align='center'
      >
        @
        {new Date().getFullYear()}
        {" developped by Minami Jiro"}
      </Typography>
      <Box mr={3}>
        <Grid container justify="center">
          <a href="https://medium.com/@szmizorsz/nft-fractions-decentralised-exchange-introduction-3e696f27c065" target="_blank" rel="noopener noreferrer" >
            <DescriptionIcon color='disabled' className={classes.icon} />
          </a>
          <a href="https://github.com/dmb-dev87/react.js-solidity_nft-fractions-dex" target="_blank" rel="noopener noreferrer" >
            <GitHubIcon color='disabled' className={classes.icon} />
          </a>
          <a href="" target="_blank" rel="noopener noreferrer" >
            <LinkedInIcon color='disabled' className={classes.icon} />
          </a>
          <a href="mailto:dmbdev800@gmail.com" target="_blank" rel="noopener noreferrer" >
            <EmailIcon color='disabled' className={classes.icon} />
          </a>
        </Grid>
      </Box>
      <Grid item md={1} />
    </Box>
  );
}

export default Footer;