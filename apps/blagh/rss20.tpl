<?xml version="1.0" encoding="UTF-8"?>

%{
fn statpost {
    f = $1

    post_uri = `{echo $f | sed 's,^'$sitedir',,'}
    #title=`{basename $f | sed 's/^[0-9\-]*_(.*)\.md$/\1/; s/_/ /g' }
    title=`{read $f/index.md}
    date=`{date `{mtime $f | awk '{print $1}'}} # rss 2.0 spec says pubDate should conform to rfc822
    # TODO: use mtime(1) and ls(1) instead of lunix's stat(1)
    #stat=`{stat -c '%Y %U' $f}
    #mdate=`{/bin/date -Rd $stat(1)} # Not used because it is unreliable
    post_uri=$base_url^`{cleanname `{echo $f | sed -e 's!^'$sitedir'!!'}}^'/'
    by=`{ls -m $f | sed 's/^\[//g; s/].*$//g' >[2]/dev/null}
    ifs=() {summary=`{ cat $f/index.md |strip_title_from_md_file| ifs=$difs {$formatter | escape_html} }}
}

%}

<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
    <channel>
        <atom:link href="%($base_url^$req_path%)" rel="self" type="application/rss+xml" />
        <title><![CDATA[%($siteTitle%)]]></title>
        <link>%($base_url^$req_path%)</link>
        <description><![CDATA[%($blogDesc%)]]></description>
        <language>en-us</language>
        <generator><![CDATA[Tom Duff's rc, and Kris Maglione's clever hackery]]></generator>
%{
        # <webMaster>uriel99+rss@gmail.com (Uriel)</webMaster>
        for(f in `{get_post_list $blagh_root$blagh_dirs}) {
            statpost $f
            # Hack to aproximate the last build date 
            #(use the mdate from last posted item)
            # Commented out for now because maybe a wrong value is worse than no value
            #if(~ $#last_build_date 0) {
                #last_build_date='<lastBuildDate>'^$"mdate'</lastBuildDate>'
                #echo $last_build_date
            #}
%}
        <item>
            <title><![CDATA[%($title%)]]></title>
            <author><![CDATA[%($by%)@noreply.cat-v.org (%($by%))]]></author>
            <link>%($post_uri%)</link>
            <guid isPermaLink="true">%($post_uri%)</guid>
            <pubDate>%($date%)</pubDate>
            <description><![CDATA[%($summary%)]]></description>
        </item>
%        }

    </channel>
</rss>
