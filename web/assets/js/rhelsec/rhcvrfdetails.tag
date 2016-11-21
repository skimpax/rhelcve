<rhcvrfdetails>
    <div if={ isLoading } class='loader center-block'>
        <!-- <img src='puff.svg' /> -->
        <i class="fa fa-spinner fa-spin" style="font-size:36px"></i>
    </div>

    <div class="alert alert-warning" if={ error }>{ error }</div>

    <div if={ isLoading == false } >

        <h5>RH Direct Link: <a href="{ rhdirectlink }">{ rhdirectlink }</a></h5>
        <pre id="json">{ prettyjson }</pre>  

        <div if={ items == null || items.length == 0 }>
            <div class="alert alert-info">No CVRF emitted.</div>
        </div>
    </div>

    <script>

        this.items = [];
        this.isLoading = false;
        this.error = null;

        var self = this

        convert2htmllink(jsonlink) {

            // https://access.redhat.com/documentation/en/red-hat-security-data-api/version-0.1/red-hat-security-data-api/
            // remove '.json' in URL to get link hat will return data in plain HTML 
            return jsonlink.replace(/\.json$/, ".xml");
        }

        convert2htmllinkXXX(rhsa) {

            // https://access.redhat.com/documentation/en/red-hat-security-data-api/version-0.1/red-hat-security-data-api/
            // remove '.json' in URL to get link hat will return data in plain HTML 
            //return jsonlink.replace(/\.json$/, ".xml");
            return '/rhdb/cvrfdetails/' + rhsa;
        }

        doRhelGrab() {

            var queryparams = $('#myform1').serialize();
            // console.log(queryparams);

            this.doApiRequest(queryparams);
        }

        doApiRequest(rhsa) {

            var apiurl = "/api/rhdb/cvrf/" + rhsa;

            self.isLoading = true;
            self.update();

            $.getJSON(apiurl, function(results) {
                self.items = results.data;
                console.log(results.data);
                // document.getElementById("json").innerHTML = JSON.stringify(results.data.data, undefined, 2);
                self.rhdirectlink = results.data.rhlink;
                self.prettyjson = JSON.stringify(results.data.data, undefined, 2);
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
                self.update()
            });
        }

        self.on('mount', function(){

            self.doApiRequest(opts.rhsa);
        })

    </script>

</rhcvrfdetails>
