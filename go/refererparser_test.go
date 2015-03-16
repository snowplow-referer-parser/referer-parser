package refererparser

import (
	"testing"
)

var testData = []struct {
	spec   string
	uri    string
	medium string
	source string
	term   string
	known  bool
}{
	{
		"Google Images search",
		"http://www.google.fr/imgres?q=Ogham+the+celtic+oracle&hl=fr&safe=off&client=firefox-a&hs=ZDu&sa=X&rls=org.mozilla:fr-FR:unofficial&tbm=isch&prmd=imvnsa&tbnid=HUVaj-o88ZRdYM:&imgrefurl=http://www.psychicbazaar.com/oracles/101-ogham-the-celtic-oracle-set.html&docid=DY5_pPFMliYUQM&imgurl=http://mdm.pbzstatic.com/oracles/ogham-the-celtic-oracle-set/montage.png&w=734&h=250&ei=GPdWUIePCOqK0AWp3oCQBA&zoom=1&iact=hc&vpx=129&vpy=276&dur=827&hovh=131&hovw=385&tx=204&ty=71&sig=104115776612919232039&page=1&tbnh=69&tbnw=202&start=0&ndsp=26&ved=1t:429,r:13,s:0,i:114&biw=1272&bih=826",
		"search",
		"Google Images",
		"Ogham the celtic oracle",
		true,
	},
	{
		"Yahoo! Images search",
		"http://it.images.search.yahoo.com/images/view;_ylt=A0PDodgQmGBQpn4AWQgdDQx.;_ylu=X3oDMTBlMTQ4cGxyBHNlYwNzcgRzbGsDaW1n?back=http%3A%2F%2Fit.images.search.yahoo.com%2Fsearch%2Fimages%3Fp%3DEarth%2BMagic%2BOracle%2BCards%26fr%3Dmcafee%26fr2%3Dpiv-web%26tab%3Dorganic%26ri%3D5&w=1064&h=1551&imgurl=mdm.pbzstatic.com%2Foracles%2Fearth-magic-oracle-cards%2Fcard-1.png&rurl=http%3A%2F%2Fwww.psychicbazaar.com%2Foracles%2F143-earth-magic-oracle-cards.html&size=2.8+KB&name=Earth+Magic+Oracle+Cards+-+Psychic+Bazaar&p=Earth+Magic+Oracle+Cards&oid=f0a5ad5c4211efe1c07515f56cf5a78e&fr2=piv-web&fr=mcafee&tt=Earth%2BMagic%2BOracle%2BCards%2B-%2BPsychic%2BBazaar&b=0&ni=90&no=5&ts=&tab=organic&sigr=126n355ib&sigb=13hbudmkc&sigi=11ta8f0gd&.crumb=IZBOU1c0UHU",
		"search",
		"Yahoo! Images",
		"Earth Magic Oracle Cards",
		true,
	},
	{
		"Powered by Google",
		"http://isearch.avg.com/pages/images.aspx?q=tarot+card+change&sap=dsp&lang=en&mid=209215200c4147d1a9d6d1565005540b-b0d4f81a8999f5981f04537c5ec8468fd5234593&cid=%7B50F9298B-C111-4C7E-9740-363BF0015949%7D&v=12.1.0.21&ds=AVG&d=7%2F23%2F2012+10%3A31%3A08+PM&pr=fr&sba=06oENya4ZG1YS6vOLJwpLiFdjG91ICt2YE59W2p5ENc2c4w8KvJb5xbvjkj3ceMjnyTSpZq-e6pj7GQUylIQtuK4psJU60wZuI-8PbjX-OqtdX3eIcxbMoxg3qnIasP0ww2fuID1B-p2qJln8vBHxWztkpxeixjZPSppHnrb9fEcx62a9DOR0pZ-V-Kjhd-85bIL0QG5qi1OuA4M1eOP4i_NzJQVRXPQDmXb-CpIcruc2h5FE92Tc8QMUtNiTEWBbX-QiCoXlgbHLpJo5Jlq-zcOisOHNWU2RSHYJnK7IUe_SH6iQ.%2CYT0zO2s9MTA7aD1mNjZmZDBjMjVmZDAxMGU4&snd=hdr&tc=test1",
		"search",
		"Google",
		"tarot card change",
		true,
	},
	{
		"Google search #1",
		"http://www.google.com/search",
		"search",
		"Google",
		"",
		true,
	},
	{
		"Google search #2",
		"http://www.google.com/search?q=gateway+oracle+cards+denise+linn&hl=en&client=safari",
		"search",
		"Google",
		"gateway oracle cards denise linn",
		true,
	},
	{
		"Yahoo! search",
		"http://es.search.yahoo.com/search;_ylt=A7x9QbwbZXxQ9EMAPCKT.Qt.?p=BIEDERMEIER+FORTUNE+TELLING+CARDS&ei=utf-8&type=685749&fr=chr-greentree_gc&xargs=0&pstart=1&b=11",
		"search",
		"Yahoo!",
		"BIEDERMEIER FORTUNE TELLING CARDS",
		true,
	},
	{
		"PriceRunner search",
		"http://www.pricerunner.co.uk/search?displayNoHitsMessage=1&q=wild+wisdom+of+the+faery+oracle",
		"search",
		"PriceRunner",
		"wild wisdom of the faery oracle",
		true,
	},
	{
		"Bing Images search",
		"http://www.bing.com/images/search?q=psychic+oracle+cards&view=detail&id=D268EDDEA8D3BF20AF887E62AF41E8518FE96F08",
		"search",
		"Bing Images",
		"psychic oracle cards",
		true,
	},
	{
		"IXquick search",
		"https://s3-us3.ixquick.com/do/search",
		"search",
		"IXquick",
		"",
		true,
	},
	{
		"AOL search",
		"http://aolsearch.aol.co.uk/aol/search?s_chn=hp&enabled_terms=&s_it=aoluk-homePage50&q=pendulums",
		"search",
		"AOL",
		"pendulums",
		true,
	},
	{
		"AOL search.com",
		"http://www.aolsearch.com/search?s_pt=hp&s_gl=NL&query=voorbeeld+cv+competenties&invocationType=tb50hpcnnbie7-nl-nl",
		"search",
		"AOL",
		"voorbeeld cv competenties",
		true,
	},
	{
		"Ask search",
		"http://uk.search-results.com/web?qsrc=1&o=1921&l=dis&q=pendulums&dm=ctry&atb=sysid%3D406%3Aappid%3D113%3Auid%3D8f40f651e7b608b5%3Auc%3D1346336505%3Aqu%3Dpendulums%3Asrc%3Dcrt%3Ao%3D1921&locale=en_GB",
		"search",
		"Ask",
		"pendulums",
		true,
	},
	{
		"Mail.ru search",
		"http://go.mail.ru/search?q=Gothic%20Tarot%20Cards&where=any&num=10&rch=e&sf=20",
		"search",
		"Mail.ru",
		"Gothic Tarot Cards",
		true,
	},
	{
		"Yandex search",
		"http://images.yandex.ru/yandsearch?text=Blue%20Angel%20Oracle%20Blue%20Angel%20Oracle&noreask=1&pos=16&rpt=simage&lr=45&img_url=http%3A%2F%2Fmdm.pbzstatic.com%2Foracles%2Fblue-angel-oracle%2Fbox-small.png",
		"search",
		"Yandex Images",
		"Blue Angel Oracle Blue Angel Oracle",
		true,
	},
	{
		"Ask toolbar search",
		"http://search.tb.ask.com/search/GGmain.jhtml?cb=AYY&pg=GGmain&p2=%5EAYY%5Exdm071%5EYYA%5Eid&n=77fdaa55&qid=c2678d9147654034bb8b16daa7bfb48c&ss=sub&st=hp&ptb=F9FC6C22-EAE6-4D1E-8126-A70119B6E02F&si=flvrunner&tpr=hst&searchfor=CARA+MEMASAK+CUMI+CUMI&ots=1219016089614",
		"search",
		"Ask Toolbar",
		"CARA MEMASAK CUMI CUMI",
		true,
	},
	{
		"Ask toolbar search #2",
		"http://search.tb.ask.com/search/GGmain.jhtml?&st=hp&p2=%5EZU%5Exdm458%5EYYA%5Eus&n=77fda1bd&ptb=F0B68CA5-4791-4376-BFCC-5F0100329FB6&si=CMKg9-nX07oCFSjZQgodcikACQ&tpr=hpsbsug&searchfor=test",
		"search",
		"Ask Toolbar",
		"test",
		true,
	},
	{
		"Dale search",
		"http://www.dalesearch.com/?q=+lego.nl+%2Fclub&s=web&as=0&rlz=0&babsrc=HP_ss",
		"search",
		"Dalesearch",
		" lego.nl /club",
		true,
	},
	{
		"Twitter redirect",
		"http://t.co/chrgFZDb",
		"social",
		"Twitter",
		"",
		true,
	},
	{
		"Facebook social",
		"http://www.facebook.com/l.php?u=http%3A%2F%2Fwww.psychicbazaar.com&h=yAQHZtXxS&s=1",
		"social",
		"Facebook",
		"",
		true,
	},
	{
		"Facebook mobile",
		"http://m.facebook.com/l.php?u=http%3A%2F%2Fwww.psychicbazaar.com%2Fblog%2F2012%2F09%2Fpsychic-bazaar-reviews-tarot-foundations-31-days-to-read-tarot-with-confidence%2F&h=kAQGXKbf9&s=1",
		"social",
		"Facebook",
		"",
		true,
	},
	{
		"Odnoklassniki",
		"http://www.odnoklassniki.ru/dk?cmd=logExternal&st._aid=Conversations_Openlink&st.name=externalLinkRedirect&st.link=http%3A%2F%2Fwww.psychicbazaar.com%2Foracles%2F187-blue-angel-oracle.html",
		"social",
		"Odnoklassniki",
		"",
		true,
	},
	{
		"Tumblr social #1",
		"http://www.tumblr.com/dashboard",
		"social",
		"Tumblr",
		"",
		true,
	},
	{
		"Tumblr w subdomain",
		"http://psychicbazaar.tumblr.com/",
		"social",
		"Tumblr",
		"",
		true,
	},
	{
		"Yahoo! Mail",
		"http://36ohk6dgmcd1n-c.c.yom.mail.yahoo.net/om/api/1.0/openmail.app.invoke/36ohk6dgmcd1n/11/1.0.35/us/en-US/view.html/0",
		"email",
		"Yahoo! Mail",
		"",
		true,
	},
	{
		"Outlook.com mail",
		"http://co106w.col106.mail.live.com/default.aspx?rru=inbox",
		"email",
		"Outlook.com",
		"",
		true,
	},
	{
		"Orange Webmail",
		"http://webmail1m.orange.fr/webmail/fr_FR/read.html?FOLDER=SF_INBOX&IDMSG=8594&check=&SORTBY=31",
		"email",
		"Orange Webmail",
		"",
		true,
	},
	{
		"Internal HTTP",
		"http://www.snowplowanalytics.com/about/team",
		"internal",
		"",
		"",
		false,
	},
	{
		"Internal HTTPS",
		"https://www.snowplowanalytics.com/account/profile",
		"internal",
		"",
		"",
		false,
	},
	{
		"Referrer with no dot in host",
		"http://localhost/search?q=test",
		"unknown",
		"",
		"",
		false,
	},
}

func check(err error) {
	if err != nil {
		panic(err)
	}
}

func TestRefererParser(t *testing.T) {
	for _, tdata := range testData {
		res := Parse(tdata.uri)
		res.SetCurrent("https://www.snowplowanalytics.com/")
		if tdata.known != res.Known {
			t.Errorf("Bad known for %+v, expected:%+v, got:%v", tdata, tdata.known, res.Known)
		}
		if tdata.source != res.Referer {
			t.Errorf("Bad referer for %+v, expected:%+v, got:%v", tdata, tdata.source, res.Referer)
		}
		if tdata.medium != res.Medium {
			t.Errorf("Bad medium for %+v, expected:%+v, got:%v", tdata, tdata.medium, res.Medium)
		}
		if tdata.term != res.SearchTerm {
			t.Errorf("Bad term for %+v, expected:%+v, got:%v", tdata, tdata.term, res.SearchTerm)
		}
	}
}
