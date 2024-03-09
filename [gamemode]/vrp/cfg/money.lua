local cfg = {}

cfg.open_wallet = 5000000
cfg.open_bank = 20000000

cfg.display_css = --[[
  @font-face {
    font-family: 'Burlacu_Fonts';
    src: url('https://cdn.discordapp.com/attachments/438989579786387466/938427059104006164/Kanit-SemiBold.ttf');
  }
  .div_money{
    position: absolute;
    font-family: Comic Sans MS;
    top: 40px;
    right: 15px;
    font-weight: 100;
    border-left: 3px solid #00fff2;
    border-bottom: 3px solid #00fff2;
    text-align: center;
    border-radius: 5px 5px 5px 5px;
    background: rgba(0,0,0, 0.4);

    padding:3px;
    font-size: 16px;
    width: 170px;
    color: rgb(255, 255, 255);

  }
  .div_bmoney{
    position: absolute;
    font-family: Comic Sans MS;
    top: 83px;
    right: 15px;
    font-weight: 100;
    border-left: 3px solid #00fff2;
    border-bottom: 3px solid #00fff2;
    text-align: center;
    background: rgba(0,0,0, 0.4);
    border-radius: 5px 5px 5px 5px;
    padding:3px;
    font-size: 16px;
    width: 170px;
    color: rgb(255, 255, 255);

  }
  .div_donationCoins{
    position: absolute;
    font-family: Comic Sans MS;
    top: 126px;
    right: 15px;
    font-weight: 100;
    border-radius: 5px 5px 5px 5px;
    text-align: center;
    background: rgba(0,0,0, 0.4);
    border-left: 3px solid #009fbf;
    border-bottom: 3px solid #009fbf;
    padding:3px;
    font-size: 16px;
    width: 170px;
    color: rgb(255, 255, 255);

  }
  .div_Giftpoints{
    position: absolute;
    font-family: Comic Sans MS;
    top: 169px;
    right: 15px;
    font-weight: 100;
    border-radius: 5px 5px 5px 5px;
    text-align: center;
    background: rgba(0,0,0, 0.4);
    border-left: 3px solid #009fbf;
    border-bottom: 3px solid #009fbf;
    padding:3px;
    font-size: 16px;
    width: 170px;
    color: rgb(255, 255, 255);

  }
  .div_money .symbol{
    position:absolute;
    content: url('https://cdn-icons-png.flaticon.com/128/3141/3141885.png');
    left: 8px;
    top: 7.7px;
    width: 16px;
    height: 16px;
  }
  .div_bmoney .symbol{
    position:absolute;
    content: url('https://cdn-icons-png.flaticon.com/128/275/275366.png');
    left: 8px;
    top: 8px;
    width: 16px;
    height: 16px;
  }
  .div_donationCoins .symbol{
    position:absolute;
    content: url('https://cdn-icons-png.flaticon.com/128/7311/7311162.png');
    left: 8px;
    top: 8px;
    width: 16px;
    height: 16px;
  }
  .div_Giftpoints .symbol{
    position:absolute;
    content: url('https://cdn-icons-png.flaticon.com/128/214/214305.png');
    left: 8px;
    top: 8px;
    width: 16px;
    height: 16px;
  }
 
]]
return cfg