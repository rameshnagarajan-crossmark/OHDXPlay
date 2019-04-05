(function(window) {
  'use strict';
  window['OHIMAGES'] = window['OHIMAGES'] || {};
  OHIMAGES['icon_check_green'] = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAACsElEQVRIiaWVz08TQRTH558AGuIf0wvQ3VnwRwgSo0aBhBgSjaZeuPBmUGJADGDUk0aJIRqxlSMnIxG7M2tKC6gRaCtKClGLBbqxULrPg03ZQrsUOslc3ux+vjPzvvMeIQ7DLcFFde5VDO5XJPtODbauSpakgkVVnb2hOvfWT0K1E6PoqAtCLRXwnErYppKh84RtTYfRJr27piy4EmBnqcHWDwcXTlVAokFCiyNcDUAHlZA9KjwvIpmlGqyr5M5Vyazjwu0img7NhfCpvipVsp+Vwm15+aO8hRN5AU2H0UqhrcF+PGXc2osJeGrffboSeEd4BOc3l3Fs5R2e/ng77y63BBfxGOxmJfBLoSGMmWtoIWIoGcXWYP9ePgL8BqGSTxwX3hYexqi5hoiIX7dW8HJoaF/C+Wui6uybPahJhudnBrHR4IdeSywHX0zF8cLMYLG3ESOqZCl7kC+8wGTGRF/8Q0mRztkHBfBzwYHilhWQIFSwTXuwd/ElpnbTmLGy6F8NHBC5MvcQo7k7/7L1Ay+G7jnZ1SRUwrI92GhwHIj4MLWbxl0ri+PxaTyZs1/X3CNcSsXRQsT5zWVsCw8750mwBaIY3L9/odHg2L80nj/J+Oo0ej8/wYi5ihYizm7EsD10CFwyVAzuJ1Tn3mKLmmR4Z/EVmjmRZMZECxHDG1HsCN8vy2Wazq6RJr27RpVsp5TIQMSHW5m/iDmflwtXJdtRpvqqCCGE/K/9pT++G/Hh+8QnbA+PlP1GFKPnWb4WuSW4VAEJpx+ajN6y4aqAxIEG1CChpZJeYLNm9kC5zpdtA9oqbTgewTodu5qmQzOV8OvIAoL9pgE44wgvyIkOY6XctW/Xaar3PK4LQm1ZcPuon4Rqj+RXqeQTVLAFKsGkBlungkWpYD6PYNfdElxOjH/rAvhs8YLWZAAAAABJRU5ErkJggg==';
  OHIMAGES['icon_map_orange'] = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAACbUlEQVRIiZ2Vz2sTQRTHB72pJf44VATBg1BBmpsK/gkirZdFs/veGBHUg1DxUgTBRtT2oCCUgqIgFooQBbtmZ2ZDrHjRg3+HhopKf0BB7I+vhzXdTXcmJg28Q8J77zPv+74zEdD0CormEXMFkb9PdPHBe3kAisdhqAlN72DOn3AnG9qAYSQhFxFzBS/Ke625VW8/Yr4HzctpzWZtZAXlExnQvIxYTrQmQjjUh8gfRcwL1vz2aKDmn8wDNC9D0xw0r7dPRC9h5KL9ILQGFUwhkvdzcMU1zAaDKSCSk0IIgdlgEDp43Q6yNl9C/cLpzYM2vAKMf6cNpGg+A+CHbdK1QG07ykRdnrXuqeEVoGmulecEpBL6Z6BpactCF52uEUJAybGuAUlBMLVlgj8Ih/q2DYApFVG/dDj9zh9yEsVc2RYA2r+e/EarUDyOOLjmdFDk30XoHe0N8LZ8BFFwA4pnuvB8a5oFKHmzM0DJx7mTRHIy0+gXFNcQBxqGVi2Xcx0hDbgBmr9C8W1E/ih06RwaXgFjYzug+BTq5WOoejs3wbEcttpXcdkNyMdPmFLRuUjDcV4qGukFAJjgidsp9NwywXhvAM0frc0bXgFGfrM4ay6ZLnjQJYDWYNjLyyOfuevoU/Y9+o9EDBjagKKrqTTlg1YXOaILAAOGP2eWe7nr+5EALFraPB7LYYSlfmj60hsgpAEoeuN8lt3QleTPiL53BKSX5+JxGJ7+t9hOjX9D01OEQ4eEEAK1K7sQ0wgMNTsCUo1LRetEmldg/EcIS/1W607z7uQVoB9Zg7juURbU7NQ4V1f19kDxLRhqQvHMX3js5QrQW72DAAAAAElFTkSuQmCC';
  OHIMAGES['icon_account_blue'] = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAUCAYAAACXtf2DAAACQklEQVQ4ja2VTUgVURTHf1i7thZERBBEEG1tFS2iVUG0KVpFJaSlM/cOalAUvAiCqNZBuTGCwMBVUhAhtog+Xs2cc1UqgqBFKSVmWojlmxZ3fI69Z74nDtzFuXPO/3c5//sB1r3Aalr3MFoi0kss+61EvAxxj2oHGH1GlHRj3Vc/J78wrodQ+3M5QiS3sPqpfkBrsgmAQC9gNSV09wAopA1YHfeCQ02+xp2sHxAkuwAIk5vZagc43LuGjmIjRn76vPhQlnOxfoCV3xidXNxnmcboTG5uDiMTK/VgEiMOo6WcwHusjOVyPhBpsTwCd6B2QMvwDgCC5Lr3QB4C0CnrMDqFkbcU0oblBZcCtI1s8XFcyNpzH4BCYS1GJjAyWL94HmB0hFD7MDrlY5kl1H6MPM/iBUD7m4NE2rvsCOKu2g9aHmB0oMaa2QVAKEfplA2E2ud/JjFnXm7GDDVhZHYxQAazNr7DJlcxSZzpfCbUG+UFGC0tAE48XQ9AqGf9XHInt+LRqoDIHfFxcbevcecAOFXcWAmweheTtPutqSlGv2FcBza+VtmieUB8PvPxeAa4TSFtoE33VAPU4cF8izTFyvd/cn9gda4SECXdRK6VSIezwjECFxIll5cEGJ3BymusTGc5fzI/xisBHcVGAIK4KzvFPWXBUL9UB0gzAG3xfr9R4isAnH61vRJgpJmWeBtWH2Sxo1V20i57/T1VBRDIMQAi3ee7kD1AkW5dHQ/8xfcYo6PMvyFWnmDk4yqa/L8aLf0Fmm3g+bbIBCcAAAAASUVORK5CYII=';
  OHIMAGES['icon_refresh_blue'] = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAABe0lEQVQ4jZ2Sv0vDUBDHv0UR3VxE1MVFBMFBpKBT0cVBKF26CiIYC0nepX9BJi1OgpODi4hDdRe6FFRwqE3yLu3gJFKoP0DBSeoSh6TRmGChB295976f+97dA5IiXx4A3U5DNNIo1GZhmoORvGLPgLgD4nZUuHk1BnIPIOQriL3w6PwJck6g8jwAQDTSYS6MYn0Jgp8jQsEfQaXuXQckC3GAzot+Ffag8xM0RwFVR8N2NCsDwZVfoNoPIF8eAcl7EHswuIntu4nEucBLQee9iENiD9DkRmhPac7FdJqVgcElGFyCzsdxQNeakGeJhYmPYqIoQLYCwFYiQHPXA0j8GO4+wimrVja5915B3PYHaIv+AIZ74a9PXvbpwM6FA1Hra30QvBTIuQn+wTuKjZXEZ8Idh3BUmM2heHLHmYLgx2AbXyA+hWplodUWoMpV6PYuiN+CIofJRlRrEsK9/nfnQj6ArOUe7dg5kDyHkC3fjXyB4Ao0R4FZHf6r+Abn9BeFYDFN4QAAAABJRU5ErkJggg==';
  OHIMAGES['icon_target_blue'] = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAB+ElEQVQ4jZ1TzVIaQRD+LqTAn/cQUgUhVkXNe/AE6nKgdqZ3tTzzAEo0xGPwzhvEHHgAFtnu2a3yoMkl5gFMDhKwNocZFwnJJV3Vl+mvv6//BvjTgvglNL8DcQLin84TqLiDZlpZwufWTl8gkC40z0CS/dU1zxDEZ/CiwnIyyWcLkgeQvEeLt3DIqzjkVYSjbQTSBcnEYS4XSWwwA/E3hEkNXrSCQDzo+AI6voAv+2j0S/CHdWi+s1hz+rznGbQ8IExqaKYVaP66VH7AX0CjMlrRa1sJT0GjMuzAJHO9rcyTWeAbBd8oaDaO6BaNfgkUfwBJBiUnQCApSDL48RsE4uXJ7UERlL5CmNTQHhRzEjXeQzjadkM1AMk9SDI00jUo6VkyoxAmNZA8guQR2lQRjLVT/Yij63VX0f2c4Oh6/T8JOAFJhhZvwZf9vLT2oAhtqtCmavt2OM27oKudeQsq7tghStcC5TYPBmNtlZ+S5QaNfgnKnLu5HcOtbQaSCfxhHTQq5yQLVyg3OIg2oGQTmn+BeIqDaOPpFs6c6h38Yd2qjPegpAclPWjetW+yCZLvdhZxZ36JXlSAlkunNrF7vtpBI12z2xm/hTLnVlkykHxa/g9eVACZU3th//hMxFOouLOc/NyaaQVKTqDZQMsP62zgx8f2dBftNzTjoMmyOj48AAAAAElFTkSuQmCC';
  OHIMAGES['icon_person_blue'] = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAABEElEQVQ4jZ2SvUoDQRRGT1AiiOm0ygOJYJsH0EJSuDt3CSaW+wTiQ2ih4iMERVJGduYuCwHjTy0IGogp1yKokexm41441cx35oM7kDVNW8d35xj9QNw7omc0bT3z7tzs3W0h9gXR9A/GPdPqbxYLJD6dC3/j25NiQeCecgVGh0s00FGuQHRULDAuXtDAFQs87eQKvOioWBAmVURvM16/IUyqxQKAnYc1JBLEdRHXJYjMcuFGskEQNzF2F9LK70Fa4fB+G4n3OeivZ9QOVzFxC9G3mdqPGHs9RYczH+oViYTG5co03B7UENtbsLocbI/2oAbirv4f/uECfJ2UFvg6AXGfpQXGjSGwx6Ukxo3xtPMFiNxhcGqOfM4AAAAASUVORK5CYII=';
  OHIMAGES['icon_calendar_green'] = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAARCAYAAADUryzEAAABZUlEQVQ4jaWTsUpDQRBFp1G/R16prfp25qVI4S8E8gURNNmZVbSIJGCh5gf8DAXB7O5sWisRLEXEVKKmSCxCwAgR8rxwq5k9zL2wAD+Uq9sj5eGWdxvwS5UBb5LykLw05gbm4WzNpOY6BZcVkT2pTEhtl4LL5qy2SyqTIrKn4DKTmuu797wKpO5m+mh5Y5JrQJVxaYDKGEziI1LbK+Mi2MPfXS2vItiTshfkysdQNv/M84Aor6T8SMrvpDLBIE8Y5Gk653dSfpzuLADsKOcAAOi5gyovs5io8oKeOwAAO8r5QkDRb1UBAEyyF5TkLRv0VrJBb4WSvFHkcwCAot+qLo7w3w4w8CUlV6Motxj5w6jUjUodI39QlFtKroaBLxcCKne8DQBg1LYpyvOsA4rybNS2AQAqd7z91wVX5KVBSQao8kle9nN1B6T8hZETeWlg4Ks5AKqM/vEXRkCBT8tAUGVk1La/AdlsNPrXXN0bAAAAAElFTkSuQmCC';
  OHIMAGES['SVG_TEAM_MEMBER'] = '<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100"><path fill="#fff" d="m57 44h-12c-3.3 0-6 2.7-6 6v9c0 1.1 0.5 2.1 1.2 2.8 0.7 0.7 1.7 1.2 2.8 1.2v9c0 3.3 2.7 6 6 6h4c3.3 0 6-2.7 6-6v-9c1.1 0 2.1-0.4 2.8-1.2 0.7-0.7 1.2-1.7 1.2-2.8v-9c0-3.3-2.7-6-6-6z"></path><circle fill="#fff" cx="51" cy="33" r="7"></circle><path fill="#fff" d="m36.6 66.7c-0.2-0.2-0.5-0.4-0.7-0.6-1.9-2-3-4.5-3-7.1v-9c0-3.2 1.3-6.2 3.4-8.3 0.6-0.6 0.1-1.7-0.7-1.7h-9.6c-3.3 0-6 2.7-6 6v9c0 1.1 0.5 2.1 1.2 2.8 0.7 0.7 1.7 1.2 2.8 1.2v9c0 3.3 2.7 6 6 6h4c0.9 0 1.7-0.2 2.4-0.5 0.4-0.2 0.6-0.5 0.6-0.9v-5.1c0-0.3-0.1-0.6-0.4-0.8z"></path><circle fill="#fff" cx="32" cy="29" r="7"></circle><path fill="#fff" d="m76 40h-9.6c-0.9 0-1.3 1-0.7 1.7 2.1 2.2 3.4 5.1 3.4 8.3v9c0 2.6-1 5.1-3 7.1-0.2 0.2-0.4 0.4-0.7 0.6-0.2 0.2-0.4 0.5-0.4 0.8v5.1c0 0.4 0.2 0.8 0.6 0.9 0.7 0.3 1.5 0.5 2.4 0.5h4c3.3 0 6-2.7 6-6v-9c1.1 0 2.1-0.4 2.8-1.2 0.7-0.7 1.2-1.7 1.2-2.8v-9c0-3.3-2.7-6-6-6z"></path><circle fill="#fff" cx="70" cy="29" r="7"></circle></svg>';
  OHIMAGES['icon_team_member_blue'] = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAArCAYAAAA+EwvfAAAFF0lEQVRoge2Z248URRSHK4Cg7GVuXdXsKGrAyGXZmT6ndkVBZbxEWQwrLjYz0+f0sg+EByT+CQZEEzEmxgR4UqPReNmgBBJDvLxoeDM+GBNBomElcTWSAAYxLGHAhwUcevpSszurkFjJeetzzu87dbq6qlqIiGEXyvdK8D5SSCcU0LhEOqKK/vaMdlNRPlMdaWc4rYre8xLpiAIaV8C/S+C9Oe0vbyqQ1P6zErimkC8FTSL/aPd5C1otXumNCxXST+E56UIOva1GgWwYejRK/FUD/laUSrNapr5UmqWQv4vLKYFruYL/cGIs6dChWPH/VKUcWYQCD1jAByz0j1voH1dA+y3010Y+D1w1zPlVvHrbb0us/mWzNL/e4O+6M6VDb0X52A6/KcS2GY0A/htGAMC1vN48N1K/tWggbxJowujjoL9C3pYMXn0uxG+faV5r0UA+EqC7252tkP4yCoT+q/W+aWc4beh7NriS2UXvNUOAs0JvvikSQAghbKQPTYJl9ND99X45XV1nWkW7wAP1vrJnw4NGRQN+P1a8EEJ0onuXRDodH8j/oAFc8yZjAM2bGgvHIwn9f0rpjQsTAYQQQi2rrJBIY6HJkUfCXiTZ660xBchidXXQP683z5XAe8PF0y9qWWWFkfiro9ttzzn+MzbyiAQ+aDm8Jw3VVZHPT6xgpxKrD3QybiWZpzc8ZDm8RwIftJFHlK5uEd1ue3PiJzly6G1NnAFd3fKviJnsyGlvR9i3RALXVNHfPr3Zbb8tC+5SCz0dZWlnOJ0UJu24jkTaLR06JB06JNHbpaBcTPLrvM/NxuXOgrtU2H5bg2Ner7WUQ+8o4HOJLeDwZ5MsT+KQQF8m5gc+JzW/fes9QzkhxMQHyEb/sMnqIYFrOV1dN10ACr1BCXTR8JvwfUa7KaGK/iumy18OvRej0/fPyfZV5tt93oI4y/ZV5gvRPycSogk9llPdKRTyz0YODv0Wtpx16PWLLeADEvm8aWKJfF4B7bcKvCgYL6PdlEI6YRQLaFSY7j5tzS8Fk11+Wf8wFd4IQqfDXm7TWZDANWGaLLj3EUIIifTNZMVfLQzw1w2FgeoqU39jgHZwZbB1pir+inUUh+6uj922rGq3FEAC14IHEVX0Hm8VgNLlx66dg20zTFvbDADpQkP7NLF5S4zf660Jac8L/wPcEAAS6MyNCiCBzggFtP9GBVDI+0TXksE7kvZC1yOA1PxDXg/dLoQQ4s7S8M1ZrK6OOgtLoIvCdWfWJ5jXy6VWAczr5dI16l13ZtSmTiKdzmh+InRbHXUOVth4H5PRbkoB/znl6gOdEcv7O+tjz9XcFdMNYw3CTQBkkTcEn7ccj4zOEFEGNG45HgXjZqHydMsBbIc/CfNReuPCnPZ2NCs+5/gvdOj1i0NjxtzUTRpAIV+yC5VHwvxSmrFZgJRmDNVQ4AfiDjVTApDIv04cSKYH4JbC4G3JGqYAcLlvR4MvXSsArJUDHQq8Y0l+sQAKaNQkeReWl7QaoAvLS4x8gUbjZuDT6x1AAh+MngH0Bq93ALun/GQkgBBmd/XB5c/W1NMsgK2ppz6GyQkv+E8ifiaAvpBIYzbQySsmgY5K9HY1/GRY3t/ZzK2EAhq3Vg501Ifo7nZnS6TdEujoNTmRxhR4n+eKlaeMxE92KE3vNTED706rmMmMdnClRDqS2DroH87rtdZ/rTd0ZLSbspBeVuAdqz+US+CaAu+Y5VR3tvpP/9+Yzcth2H4yoQAAAABJRU5ErkJggg==';
  OHIMAGES['icon_cancel_location_blue'] = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABcAAAAWCAYAAAArdgcFAAADW0lEQVQ4jZ3TT2wUdRQH8G/dmXW3W2tpZ36za8EsiGi70J3fWxNDPLgHNCbexEnZ/f1GFmO00YsX0lg1VmV3GsQ/gMYWD8ajxqSJgQYDUg7+Q4ORoDEmDQSRKCgY0ISq1eelO93tbivtS95l5s3nzbz3G2CZMRxDuhzBaBDB2cAEV0z8MGJi3zMxrF6uCQAIDGwKDFwJTHBDGvgjMHDfsuAdcayqGLg82nMr7+4Wc2i0hd+5604OTHDFwO9BDGuQdEtpJ6c2XCtejmBPYILHt3h8/sTX/FrK4sAEf7H7Vf7u/ffCZiMm9sGR6pIgzcL1j1luUWUyXrQZms6XYp1U2PZUvHW6Ckw89gj/9NVxPv7mGzw1cYB3tl1fO6IzEKS5Ll31s5PTI13rvG4ASKwvOF3Z4qAt1TlBmp+PmXUzPn34EM9MT/OelU7d9YqBqyHukNovSI/bpGYEaRZST1vkHxFS/VnbfHtbewh8Un6RT390mI8+O8Q/fvYpv9x5Q+1YToV4hyzcDQBJt5S2SL9kS/1bw1eR5kJy3aXABB98YoDPHJ3kXTe2cmCCJ4cG+dSHB0O8HMHrDXgYjp8QpIfDL5nN7JpND5cNXNx7c4p3dSTqRjF6+9rqSK48DXQvjM+GLdVELe6Q/+gLwMaKgQvNzvlz8Shva19VAIB5+PB1wtXbhatfSVF/TyJTSoanqWbhyd6tmSHACaIYqZg4UTZwsWLim8039fLqDZu5nby1jXg+b1hu8S3LVZOC9FUh9flmc7dJzQjXPyZIj6WovwcAOtxSR/V+A955R+Ge2nGIXOFxm/RfNqnLFvlHBOkxR+ovGxvpKQAti+J2Tp0VsnhIkB533MKTmYwXTedLsboFeF7EkvqD+Q3abvHFonhDSjXabMGdcsuD82tX9Pnrl4p/2/T0UPHt+bVWVg205nTq2nHS7Ei9Fxu9+Bys+psuWOp/BKlfloQL0tzl+jvCJZP+/P/q6/EFjtvcW6lzVp++bUVO329L9e+S8HjfAystUjsbfpaFmpGe6soWBx1S79qk/l4Ur0Y6X4oJWXxIkD7ZFHXVx3bO9+B5keozs0scFqR/XRSviRaR67/XIbVfSH1BkB5L9m7NLFQMAHD8hJVVA4L0STunv0fGawOA/wBU1z2DNI3gxwAAAABJRU5ErkJggg==';
  OHIMAGES['icon_clock_blue'] = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAACsElEQVRIiaWVO08UURTHbwvLiuzcxy5LYcXb2bnnEhJDYVAKJboFZICZe+6GhsfCdzCUWtoYMbHxKwhYKFhI/AighmhpjAXPxrBEC9ndO8s+JuEmU+zNmf/v/P97JoeQJqfNnepxPLPKJL4TYPa5xDMu8UyA2WdSb3EVrLS5Uz3NNOqeDukzkQufM9DnHPBvs4dJvKAyfNOuMBNLnOb0Iwb6uJXwFRDoYzYSTjYV5ypYYaBLkZdl+F54eiGppvuJMAkiTCKppvsFmEUOuF0DKXEVFht3LvGial1/uymDu60cp9XMOAM8sCFXnNC+fLcdCwP8dOOOn4qVKSEkO1pwmKd3LchRYmg+XY0GzCu783ri1DVzDHSJgS5R18zVhVhOuNQvCSH/R9GelkaxcMA1K++1ejWOa+5ZLs6dXj9LHM+sWtQPjWKIAyCEEApmp1KnwiJhUm+VL4SnF64PwKWKHugNwhR+LV9QF/uuC0iq6f4qwOwTBnhSAYzlk3EA1AueNXQwlk9a03gSG0BV8KTqQP/ucs1wTID+EieiLtcMM9BH1YHAXynpD9bWZWB2IBKR8HDTulhsBCCEkPRIOGpDGODP2qZoTi9XGgbzNjqmgNvNAPUgQprXEYCnP0bGtPZDS6uZ8dgQGf5Ie/O3yvdCFibsD4325bsJIYRwwHXL9kF2tOC0gji9frbzdthV/t2tHlOu8Ht10vBFpbhdYSaSrad340Ai4jL8bC2hw8RwICJFbCSctHcBAzwQ7tz9VuJCFibszhnoEpP6Yd1irsJi7cKhYHYo4FIGZgfIkN9BhvyOlPQHKeBS5A+9FKc5vdy0o0snR/aLsVamxMMUBA9iZyoUPuVS/4mxi8854HpkwcQ9Tq+f5SosCg83qcQ9JvUpk/qUStwToDdoTi9XRrHB+QfvD7DEmvYubgAAAABJRU5ErkJggg==';
  OHIMAGES['icon_project_detail'] = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAZ0lEQVRIie2SyQnAMAwERynTVgtGLiEdGuSClEfA/4BDDjygh2BhYRlYvIc9Nqwr1hVC5hdYV6oH1YPSMsD4r94zBYRQWsY83TPR91kWLYsmEIJ1Pff/pEWl5REwT/MLCME8LYv+xwFnqQv0OzEdygAAAABJRU5ErkJggg==';
  OHIMAGES['icon_dollar'] = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAABTklEQVRIie2VvUrEQBSFT2Hj2giiiGBjY79WdsqWNjZb2AiCrGhMZkYUbIQUFvsEFvsE/jU+gWCpIZO5owha6AOIrMqWbiwySVx0m0maRQ9MMxfOd+bnzgD/Kk2c4mwMFsAJa+DqrAcgVAubN7PFzbn0wagLTjEYdSHoNYMwegMP5wskD6qZOZc+GkElgV6OgkXHybwie4CQLEmqnn7UtsOpbCVb19N2ADfaMIAOBM3YJ+2ntatxMHoxW9GGoCacoFouxKM5MKV7bhCPniGoidX7sXIgvj8EHq5A6HMw1clBqg1XL5UDSdUIKmBUB9MPBvSOvbvJciEAsKsmwOgDnGJ4ct3ORKiWSXnya53TY9LV0b4dwAlrptE+4WkX9dNhk34EXnSQn4VcsAMAgKcP+z4VnGIwfWRvnmrndjF/GlJjdQEul4ubf9fg/gd/Xl+1FNrzusZDigAAAABJRU5ErkJggg==';
})(window);