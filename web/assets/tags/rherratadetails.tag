<rherratadetails>
    <hr>
    <div if={ isLoading } class='loader center-block'>
        <!-- <img src='puff.svg' /> -->
        <i class="fa fa-spinner fa-spin" style="font-size:36px"></i>
    </div>

    <div class="alert alert-warning" if={ error }>{ error }</div>

    <div if={ isLoading == false } >

        <h5 if={ rhdirectlink != null }>RH Direct Link: <a href="{ rhdirectlink }">{ rhdirectlink }</a></h5>
        <br>
        <div id="idjsonpanel1"></div>

        <div if={ purejson == null || purejson.length == 0 }>
            <div class="alert alert-info">No data retrieved.</div>
        </div>
    </div>

    <script>

        this.rhdirectlink = null;
        this.purejson = null;
        this.isLoading = false;
        this.error = null;

        var self = this

        doApiRequest(errata, type) {

            var apiurl;

            switch (type) {
                case 'CVRF': apiurl = "/api/rhdb/cvrf/" + errata; break;
                case 'CVE': apiurl = "/api/rhdb/cve/" + errata; break;
                case 'OVAL': apiurl = "/api/rhdb/oval/" + errata; break;
                default: return; break;
            }

            self.rhdirectlink = null;
            self.purejson = null;
            self.isLoading = true;
            self.error = null;
            self.update();

            $.getJSON(apiurl, function(results) {
                console.log(results.data);
                if (results.data !== null) {
                    self.rhdirectlink = results.data.rhlink;
                    self.purejson = results.data.jsondata;
                }
            })
            .done(function() {
                // alert( "second success" );
            })
            .fail(function() {
                // alert( "error" );
                self.error = "Failed to retrieve data from server!";
            })
            .always(function() {
                // alert( "finished" );
                self.isLoading = false;
                self.update();

                $('#idjsonpanel1').jsonView(
                    self.purejson
                );
            });
        }

        self.on('mount', function(){

            self.doApiRequest(opts.errata, opts.type);
        })

    </script>

</rherratadetails>
