<rhoval>
    <h3 class="text-primary">OVAL List</h3>

    <div>
        <h4>Search Criteria  <small>in Red Hat security DB</small></h4>
        <form id="myform1" class="form-inline" onsubmit={ doRhelGrab }>
            <div class="form-group">
                <label for="iddateafter">Since Date:</label>
                <div id="iddatepicker" class="input-group date" data-provide="datepicker" data-date-format="yyyy-mm-dd">
                    <input id="dateafter" type="text" class="form-control" name="after" required>
                    <div class="input-group-addon">
                        <span class="glyphicon glyphicon-calendar"></span>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label for="idseverity">Severity:</label>
                <select id="idseverity" class="form-control" name="severity" required>
                    <option value="critical">Critical</option>
                    <option value="important">Important</option>
                    <option value="moderate">Moderate</option>
                    <option value="low">Low</option>
                </select>
            </div>
            <button type="submit" class="btn btn-success">Apply</button>
        </form>
    </div>

    <hr>

    <div if={ isLoading } class='loader center-block'>
        <!-- <img src='puff.svg' /> -->
        <i class="fa fa-spinner fa-spin" style="font-size:24px"></i>
    </div>

    <div class="alert alert-warning" if={ error }>{ error }</div>

    <div if={ isLoading == false } >
        <div if={ items.length }>

            <table id="cvrftable" class="table table-striped table-bordered" width="100%" cellspacing="0">
                <thead>
                    <tr>
                        <!-- <th>Index</th> -->
                        <th>Released On</th>
                        <th>RHSA</th>
                        <th>Severity</th>
                        <th>CVEs</th>
                        <th>Details</th>
                    </tr>
                </thead>
                <tfoot>
                    <tr>
                        <!-- <th>Index</th> -->
                        <th>Released On</th>
                        <th>RHSA</th>
                        <th>Severity</th>
                        <th>CVEs</th>
                        <th>Details</th>
                    </tr>
                </tfoot>
                <tbody>
                    <tr each="{ value, i in items }">
                        <!-- <td>#{ i }</td> -->
                        <td>{ value.released_on }</td>
                        <td>{ value.RHSA }</td>
                        <td>{ value.severity }</td>
                        <td>
                            <virtual each="{ pkg, j in value.CVEs }">{ pkg }, </virtual>
                        </td>
                        <!-- <td><a href="{ convert2Apilink(value.resource_url) }">link</a></td> -->
                        <td><a href="{ convert2Apilink(value.RHSA) }">link</a></td>
                    </tr>
                </tbody>
            </table>

        </div>
        <div if={ items == null || items.length == 0 }>
            <div class="alert alert-info">No OVAL emitted.</div>
        </div>
    </div>


    <script>

        this.items = [];
        this.isLoading = false;
        this.error = null;

        var self = this

        convert2Apilink(rhsa) {

            return '/gui/erratadetails/oval/' + rhsa;
            
            // https://access.redhat.com/documentation/en/red-hat-security-data-api/version-0.1/red-hat-security-data-api/
            // remove '.json' in URL to get link hat will return data in plain HTML 
            // return jsonlink.replace(/\.json$/, ".xml");
        }

        doRhelGrab(e) {

            e.preventDefault();

            var queryparams = $('#myform1').serialize();
            // console.log(queryparams);

            this.doApiRequest(queryparams);
        }

        doApiRequest(criteria = null) {

            var apiurl = "/api/rhdb/oval";
            if (criteria !== null && 0 !== criteria.length) {
                apiurl += "?" + criteria;
            }

            self.isLoading = true;
            self.update();

            $.getJSON(apiurl, function(results) {
                // console.log(results);
                self.items = results.data;
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
                $('#cvrftable').DataTable();
            });
        }

        self.on('mount', function(){
            
            $('#iddatepicker').datepicker({
                autoclose: true,
                clearBtn: true,
                weekStart: 1,
                format: 'yyyy-mm-dd'
            });

            //doApiRequest();
        })

    </script>

</rhoval>
